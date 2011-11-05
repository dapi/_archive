# -*- coding: utf-8 -*-
class Phone < ActiveRecord::Base
  belongs_to :company
  include PhoneHelper
  
  before_save :normalize

  validates_presence_of :number
  validates_numericality_of :number #, :greater_than => 70000000000, :less_than => 80000000000
  
    
  #=get_current_city.prefix
  
  # 1. Убирает из номера все символы кроме цифр
  
  # 2. Приводит номер к федеральному значению в соответсвии 
  # с таблицей смены номера и замарочками мобильных операторов
    
  def self.normalize(phone,prefix)
    raise "No default prefix in normalize_phone (#{prefix})" unless prefix
    
    return nil if phone.blank?
    
    phone_old=phone
    phone=phone.to_s.gsub(/[^0-9]/,'')
    
    if phone.size==11
      phone[0]="7"
    elsif phone.size==10
      phone="7"+phone
    elsif phone.size+prefix.size==11 # TOFIX (6+5 или 5+6) некоторые имеют больше, например http://dapi.orionet.ru:3000/admin/results/edit/62691
      phone=prefix+phone
    else
      # TODO Писать в лог
      p "Phone#normalize error - bad phone number '#{phone_old}/#{phone}'"
      return phone
    end

    phone = TelefonRename.rename_number(phone)
    TelefonFederal.federal_number(phone)

  end



  
  def to_s
    number
  end

  def normalize
    self.number=Phone.normalize(self.number,get_current_city.prefix)
  end
  
  # FIX убрать куда следует
  def get_current_city
    City.find_by_name("Чебоксары")
  end
  
end
