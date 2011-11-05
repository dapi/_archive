class Company < ActiveRecord::Base
  belongs_to :company_group, :counter_cache => true
  belongs_to :city, :counter_cache => true

  has_many :phones,   :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  has_many :premises, :through => :addresses

#  has_many :emails,   :dependent => :destroy
  has_many :results
  has_many :sources,  :through => :results

  serialize  :ymaps
  serialize  :parsed_address # разобранный адрес от яндекса, см result.rb
#  serialize :dump, Hash
 
  validates_presence_of :name, :company_group_id #, :full_name
  
  accepts_nested_attributes_for :phones, :allow_destroy => true,
                                :reject_if => proc { |phone| phone['number'].blank? }
  
#  accepts_nested_attributes_for :emails, :allow_destroy => true

# ------------------------------------------------------------------------------
#  Искать по полям: Наименование, описане, адрес, телефоны (телефоны перед поиском нормализовать).
   define_index do
     indexes :name, :sortable => true
     indexes :description
     indexes addresses.address
     indexes phones.number

#     indexes [
#       phones.number, phones.person
#     ], :as => :phone
     
 #    indexes full_name, :sortable => true
#     indexes category.name, :as => :category
#     indexes emails.email, :as => :emails
#
#     # необходимо для поиска '*ксары*' => Чебоксары
     set_property :enable_star => 1
#     set_property :min_infix_len => 1 <- it's default value
   end
# ------------------------------------------------------------------------------

  

  class << self    
    
    # Давайте мне хэш телефонов и я найду компанию
    def find_by_phones(phones)
      # TODO определить тип hash/array/string/number и делать поступать соответсвенно
      
      phones.andand.each { |h|
        unless h[:number].blank?
          phone=Phone.find_by_number(h[:number])
          return phone.company if phone
        end
      }
      nil
    end
    
    def find_by_result(res)
      self.find_by_phones(res.parsed_phones) || self.find_by_name(res.normalized_name)
      
      # NOTE Слишком опасно искать по короткому имени, могут находиться похожие компании
      #|| self.find_by_short_name(res.short_name)
    end
      
  end
  
  def address
    addresses.map(&:address).join('; ')
  end
  
  def update_emails(email)
    return unless email
    email.strip!
    if self.emails.blank?
      self.emails=email
    elsif self.emails!=email
      self.emails="#{self.emails}, #{email}"
    end
  end
  
  def update_phone(h)
    
    if phone=self.phones.find_by_number(h[:number])
      # TODO Поискать чего обновлять в телефонах
      # TODO Устанавливать необходимость ручной замены, если изменился is_fax или department

      phone.update_attribute(:department,h[:department]) if phone.department.blank? && !h[:department].blank?
      phone.save!
    else

      self.phones.create(h) || raise(RecordNotSaved)
    end
    
  end
  
  
  def update_phones(phones)
    # TODO сохранять порядок телефонов (position)
    phones.andand.each{ |x| self.update_phone(x)  }
  end
  
  def update_addresses(result)
    
    if result.parsed_address[:precision]=='exact'
      address = result.parsed_address[:addr] 
    elsif not result.address.blank?
      address = result.address.sub("\n",' ').sub(/\s+/,' ').strip
    else
      return nil
    end
    
    self.addresses.create({
                            :address=>address,
                            :post_index=>result.parsed_address[:index].blank? ? nil : result.parsed_address[:index].to_s.strip.to_i,
                            :city_id=>result.city_id,
                            :parsed_address=>result.parsed_address,
                            :ymaps=>result.ymaps
                            
                          }) unless self.addresses.find_by_address(address)
  end
  
  def update_description
    # TODO Проверять не закрыт ли
    self.description=results.andand.map(&:other_info).compact.uniq.join("\n------------------------\n")
  end

  def breadcrumb
    self.company_group.breadcrumb.collect do |arr|
      arr + [self]
    end
  end

end
