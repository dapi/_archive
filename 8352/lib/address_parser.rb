# -*- coding: utf-8 -*-
require 'singleton'
require 'open-uri'
require 'hpricot'
require 'cgi'
require 'net/http'
require 'active_support'

class AddressParser
  include Singleton

  # Парсинг происходит так:
  #  - Запрос к Яндексу. С большой вероятностью, Яндекс выделит всё для больших городов. Для небольших (Новочебоксарск) - хотя бы, название города.
  #    Если Яндекс не нашёл город - маловероятно, что тот в принципе существует и адрес корректен.
  #  - Выделяется индекс и тип поселения (это легко), и номер офиса (чуть сложнее).
  #  - Далее, пытаемся отпарсить недостающие части адреса по простым правилам типа "ул. {улица}", "д. {дом}" и так далее.
  def parse(addr)    
    
    yandex_response,doc = yandex_parse(addr)
    return if yandex_response.nil?
    
    response = {
      :index => parse_index(addr),
      :ctype => parse_ctype(yandex_response[:addr]), 
      :office => parse_office(addr),
#      :city => yandex_response[:locality],
#      :street => yandex_response[:thoroughfare],
#      :house => yandex_response[:premise],
    }.merge(yandex_response)
    
    # Если Яндекс не вернул город, можно смело забить болт на дальнейший парсинг.
    return nil if response[:locality].to_s.empty?
    
    addr_stripped = strip_all_before_city(addr, response)    
    street, house = try_to_parse_street_and_house(addr_stripped) if response[:thoroughfare].nil? || response[:premise].nil?

    response[:thoroughfare] ||= street
    response[:premise] ||= house

    [response,doc]
    
  end

protected
  
  # Пытается пропустить адрес через Яндекс, выделить то что удалось.
  def yandex_parse(addr)
    escaped_addr = CGI.escape(addr)
    response = Net::HTTP.get(URI.parse(YANDEX_MAPS_URI % escaped_addr))
    doc = Hpricot.XML(response)
    [parse_yandex_response(doc),response]
  end

  # Ищет индекс.
  def parse_index(addr)
    addr.match(/(\d{6})/)
    $1.nil? ? nil : $1.to_i
  end

  # Ищет тип поселения.
  def parse_ctype(city)
    city = city.dup.mb_chars.downcase
    CTYPES.each do |ctype|
      return ctype if city.match(/#{ctype}/u)
    end
    "город"
  end

  # Парсит номер офиса. Возможные регулярные выражения описаны в OFFICE_REGEXP.
  def parse_office(office)
    OFFICE_REGEXP.each do |r|
      return $1 if office.match(/#{r}#{OFFICE_NO_REGEXP}/iu)
    end
    nil
  end

  def strip_all_before_city(addr, response)
    addr = addr.mb_chars
    city_pos = addr.index(response[:locality].mb_chars) 
    return addr if city_pos.nil?
    city_pos += response[:locality].mb_chars.length
    addr_string = addr.slice(city_pos..-1)
  end    

  # Пытается вручную вытащить улицу.
  def try_to_parse_street_and_house(addr)
    a=nil
    STREET_REGEXP.each do |r|
      return a[1], a[3] if a=addr.match(/#{r}#{STREET_NAME_REGEXP}#{HOUSE_REGEXP}/iu)
      return a[1], a[3] if a=addr.match(/#{STREET_NAME_REGEXP}#{r}#{HOUSE_REGEXP}/iu)
    end
    nil    
  end
  
  # Служебная функция, достаёт все значимые части ответа Яндекса.
  def parse_yandex_response(doc)
    el = doc.at('featureMember')
    return if el.nil?
    response = YANDEX_PARSE_XPATHS.map do |key, xpath|
      cur_el = el.at(xpath)
      text = cur_el.inner_text unless cur_el.nil?
      [key, text]
    end
    response << [:found,doc.at('metaDataProperty/GeocoderResponseMetaData/found').inner_text]
    Hash[*response.flatten]
  end

  YANDEX_API_KEY = 'ANpUFEkBAAAAf7jmJwMAHGZHrcKNDsbEqEVjEUtCmufxQMwAAAAAAAAAAAAvVrubVT4btztbduoIgTLAeFILaQ=='
  YANDEX_MAPS_URI = "http://geocode-maps.yandex.ru/1.x/?geocode=%s&key=#{YANDEX_API_KEY}"

  # NOTE Тут засада с ебучим юникодом, поэтому, пришлось размножить регэкспы в кейзах. Хотя, может быть, с ActiveSupport этого уже нет? Надо проверить.
  OFFICE_NO_REGEXP = '\s*(\d+\w{0,2})'  
  OFFICE_REGEXP = %w(оф. Оф. Офис офис)

  STREET_NAME_REGEXP = '\s*([\w\s\.]+)[\,\d\s]'
  STREET_REGEXP = %w(ул. улица)
  HOUSE_REGEXP = '[\s\,\.]+(д.|дом|Дом)?\s*(\d+[\w\/]{0,2})'

  YANDEX_PARSE_XPATHS = {
    :addr => 'GeocoderMetaData/text',
    :country => 'Country/CountryName',
    :locality => 'Locality/LocalityName',
    :thoroughfare => 'Thoroughfare/ThoroughfareName',
    :premise => 'Premise/PremiseNumber',
    :lower_corner => 'boundedBy/Envelope/lowerCorner',
    :upper_corner => 'boundedBy/Envelope/upperCorner',
    :precision => 'GeocoderMetaData/precision',
    :kind => 'GeocoderMetaData/kind',
    :pos => 'Point/pos',
  }
  
  CTYPES = %w(город поселок посёлок село аул деревня колония)
end
