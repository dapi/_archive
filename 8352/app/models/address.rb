class Address < ActiveRecord::Base
  belongs_to :company
  belongs_to :city
  belongs_to :premise
  
  serialize  :parsed_address
  serialize  :ymaps
  
  validates_presence_of :city_id, :address

  after_create :update_premise

  YANDEX_STREET_WORDS = %w{
    улица
    проспект
    бульвар
    площадь
    шоссе
    пр.
    вар 
    переулок
    проезд
    набережная
    комп.
  }

  FIRST_NAME = /\D{1}\. / # "В. Яковлева" => "Яковлева"
  END_OF_NUMBER = "-й" # "9-й" => "9", "139-й" => "139"

  def update_premise
   if self.parsed_address.blank? || !self.parsed_address[:locality]
#     logger.error "Address.update_premise: blank"
     return
   end

   unless self.city
#     logger.error "Address.update_premise: #{self.id} empty city."
     return
   end

#    precision=exact

   if self.premise.nil?
     "Address.update_premise: #{self.id} premise NIL"
     # if exist yandex street
     if self.parsed_address[:thoroughfare]
       yandex_street = self.parsed_address[:thoroughfare].mb_chars
       # 1.
       YANDEX_STREET_WORDS.each{|word| yandex_street.gsub!(word.mb_chars, '') }
       # 2.
       yandex_street.gsub!(FIRST_NAME, '')
       # 3.
       yandex_street.gsub!(END_OF_NUMBER, '')
       # 4.
       yandex_street.strip!

       street = Street.name_like(yandex_street).first

       # 5.
       unless street
         # "Тимофея Кривова" => "Т.Кривова"
         if (names = yandex_street.split(' ')) && (names.size == 2)
          street = Street.name_like("#{names.first.mb_chars[0].to_s}.#{names.last.mb_chars}").first
         end
       end

       if street
        p = Premise.find_or_create_by_city_id_and_street_id_and_number self.city.id, street.id, self.parsed_address[:premise]
        p.addresses << self
#        logger.error "Address.update_premise: #{self.id} done."
#       else
#        logger.error "Address.update_premise: street >#{yandex_street.strip}< not found."
       end
     end
#   else
#     logger.error "Address.update_premise: #{self.id} premise exist. #{self.premise.id} - #{self.premise}"
   end

  end

end
