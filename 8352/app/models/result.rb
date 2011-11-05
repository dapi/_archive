# -*- coding: utf-8 -*-
#require "phone_parser"
#require "address_parser"

class Result < ResultBase
  
  include PhoneHelper
  
  set_table_name "results"
  
  serialize  :ymaps
  
  serialize  :parsed_address # разобранный адрес от яндекса
    # parsed_address:
    # index
    # ctype
    # office
    # addr => 'GeocoderMetaData/text',
    # country => 'Country/CountryName',
    # locality => 'Locality/LocalityName', город
    # thoroughfare => 'Thoroughfare/ThoroughfareName', улица
    # premise => 'Premise/PremiseNumber', дом
    # lower_corner => 'boundedBy/Envelope/lowerCorner',
    # upper_corner => 'boundedBy/Envelope/upperCorner',
    # precision => 'GeocoderMetaData/precision', exact, near, other, :number
    # kind => 'GeocoderMetaData/kind',
    # pos => 'Point/pos',
    # found - количество найденных адресов
  
  
  serialize  :parsed_phones
  
  belongs_to :company, :counter_cache => true
  
  belongs_to :results_to_company_group, :foreign_key=>'company_group_id'
#  has_one :company_group, :through=>:results_to_company_group
  
  
  def parsed_phones_str
    return '' unless parsed_phones
    phones=[]
    parsed_phones.map { |p| 
      str=h_phone(p[:number])

      a=[]
      a << "факс" if p[:is_fax]
      a << p[:department] unless p[:department].blank?
      str+=" (#{a.join(', ')})" if a.size>0

      phones << str 
    }
    phones.join('; ')
  end

   
  def prepare(force=false)
    mark_none if updated? || force
    if none?
      parse_address
      parse_phones
      
      normalize_name
      
      mark_prepared
      
      self.save!    
    end
  end

  
  # Собственно импорт компании
  
  def import

    prepare
    
    unless self.company_group_id
      self.import_errors="Result has no company_group_id"
      mark_error
      self.save!
      raise self.import_errors
      return nil
    end
    
    if self.company
      p "Company exists, update"
      update_company()
      return 0
    elsif self.company = Company.find_by_result(self)
      p "Company found, update"
      update_company(self.company)
      return 0
    else
      p "Import new company"
      import_new_company
      return 1
    end
    
  end


  
  def import_new_company
    
    # TODO Лочить запись results при 
    self.create_company(self.company_fields)# || raise(RecordNotSaved)
    if self.company.errors.count>0
      p "Can't create company: "+self.company.errors.full_messages.join(', ')
      self.mark_error
      self.save!
    end

    
    self.company.update_phones(self.parsed_phones)
    self.company.update_addresses(self)
    self.mark_fine
    self.save!
  end
  
  
  def update_company(company=nil)
    
    # TODO Лочить запись results  и делать все в транзакции
    self.company=company if company
    self.save!
    
    # TODO Обновление и других параметров, помимо телефонов
    self.company.update_phones(self.parsed_phones)
    self.company.update_emails(self.email)
    
    self.company.update_addresses(self)
    self.company.update_description
    self.company.save!


    self.mark_partly
    self.save!
    
  end
  
  

  
  ### Помошники
  
  def company_fields
    { 
      :name=> self.normalized_name,
      :site=> self.site_url.andand.strip,
      :working_time => self.work_time.andand.strip,
      :description => self.other_info.andand.strip,
      :emails        => self.email.andand.strip,
      :city_id     => self.city_id,
      :company_group_id => self.company_group_id,
    }
  end
  
  
  
  # Убираем всякие ООО, ЗАО, кавычки и прочую лабуду, дабы получить настоящее имя компании
  
  SHORTING_WORDS = %w(ФИРМА фирма Фирма ООО ЗАО ОАО ЧП ИП РА СА ТЦ НПФ)
  
  def capitalize_first(str)
    str.mb_chars[0]=str.mb_chars[0].upcase
    str
  end
  
  def normalize_name
    sn=''

    # TODO если имя #123 и категория Аптеки то писать Аптека N123
    
    quotes_reg=Regexp.new('\"([^"]+)\"')
    # Если есть кавычки, берем то, что в них лежит и все
    if sn=self.name.scan(quotes_reg)[0]

      # Проверяем на дурацкий upcase всей строки
      if self.name.mb_chars.upcase.to_s==self.name
        self.short_name=sn[0].mb_chars.capitalize.to_s
        
        self.normalized_name=self.name.mb_chars.capitalize.to_s
        self.normalized_name.sub(quotes_reg,'"%s"' % self.short_name)
        #
      else
        self.short_name=sn[0]
        
        self.normalized_name=self.name
        capitalize_first(self.normalized_name)
        self.normalized_name
      end

    else
      r=Regexp.new('\b('+SHORTING_WORDS.join('|')+')\b',true)
      
      sn=self.name.sub(r,'').strip
      

      
      if self.name.mb_chars.upcase.to_s==self.name
        name=self.name.mb_chars.capitalize.to_s.strip
        self.short_name=sn.mb_chars.capitalize.to_s || name
      else
        name=capitalize_first(self.name).strip
        self.short_name=name if self.short_name.blank?
      end
      

      
      forms=self.name.scan(r)
      if forms.blank?
        self.normalized_name=name
      else
        is_firm=false
        forms.reject! { |f| f=="ФИРМА" ? is_firm=true : false }
        forms=forms.join(' ') + (is_firm ? ' Фирма' : '')
        if forms.blank?
          self.normalized_name=name
        else
          self.normalized_name=(forms.include?('ИП') || forms.include?('ЧП')) ? "#{forms} #{self.short_name}" : "#{forms} " + '"%s"' % self.short_name
        end

      end
    end
    
  end
  
  # FIX Вынести куда следует
  def get_current_city
    City.find_by_name("Чебоксары")
  end
  
  def parse_address
    
    self.parsed_address,self.ymaps=AddressParser.instance.parse(self.address) unless self.address.blank?
    
    unless self.parsed_address
      self.parsed_address={}
      self.city=get_city_from_phones || get_current_city
      return
    end

    
    if parsed_address[:extact] || parsed_address[:number] || parsed_address[:near]  || parsed_address[:street] 
      self.city = City.find_by_name(parsed_address[:locality]) || raise("Не могу найти населенный пункт #{parsed_address[:locality]}")
    else
      
      # FIX Грязный хак
      self.city = City.find_by_name("Чебоксары")
    end

    
  end
    
  
  def get_city_from_phones
    return nil unless phones
    p=phones.scan(/\((\d{3,4})\)/)[0]
    return nil unless p
    City.find_by_prefix(p[0])
  end
  
  def parse_phones
    self.parsed_phones=[] unless self.phones and self.other_info
    pi=PhoneParser.instance
    pp = pi.parse(phones || '') + pi.parse(other_info || '')
    found = { }
    phones = []
    pp.each { |p| 
      p[:number]=Phone.normalize(p[:number],self.city.prefix || get_current_city.prefix)
      if found[p[:number]]
        found[p[:number]][:department]=p[:department] unless p[:department].blank?
        found[p[:number]][:is_fax]=p[:is_fax] if p[:is_fax]
      else
        phones << p
        found[p[:number]]=p
      end
    }
    self.parsed_phones=phones
  end
  
end
