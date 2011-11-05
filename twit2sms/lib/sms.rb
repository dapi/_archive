# -*- coding: utf-8 -*-
class SMS
  def self.send_sms(phone,message)
    return false
    # FIX ethodError (undefined method `to_s=' for "79023270019":String):
    return unless phone.to_s="79023270019"
    
    message=URI.escape(Iconv.iconv('cp1251','utf-8',message).to_s)
    url = "http://www.shgsm.ru/esme/transmitter.php?id=#{SHGSM_KEY}&daddr=#{phone}&msg=#{message}";
    
    response = HTTParty.get(url)
    #    puts response.body, response.code, response.message, response.headers.inspect
    
    response.body=='OK' && response.code=='OK'
    
  end
end
