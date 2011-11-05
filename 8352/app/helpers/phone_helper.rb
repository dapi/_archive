# -*- coding: utf-8 -*-
module PhoneHelper
#  extend ActiveSupport::Memoizable
  
  def h_phones(phones)
    phones.map{ |p| h_phone(p) }.join(', ')
  end
  
  def h_phone(phone)
    return '' unless phone    
    str = phone.to_s
    if str=~/^79/
      "7 (#{str[1..3]}) #{str[4..6]}-#{str[7..8]}-#{str[9..10]}"
    else
      # TOFIX сделать нормально
      if str[1..4]=="8352"
        "#{str[5..6]}-#{str[7..8]}-#{str[9..10]}"
      elsif str.size>10
      "7 (#{str[0..3]}) #{str[4..5]}-#{str[6..7]}-#{str[8..10]}"
      else
        str
      end
    end
  end    

end
