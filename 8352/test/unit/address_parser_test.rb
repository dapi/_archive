# -*- coding: utf-8 -*-
require 'test/unit'
require 'address_parser'
#require 'pp'

class AddressParserTest < Test::Unit::TestCase
  def test_success_parsing
    SUCCESS_ADDRESSES.each do |line, result|
      parsed,doc = AddressParser.instance.parse(line)
      result.each do |key, value|        
        assert_equal(parsed[key], value, "Line: #{line} | #{key} was: #{parsed[key]} | #{key} should be: #{value}")
      end
    end
  end

protected
  SUCCESS_ADDRESSES = {
    "г. Санкт-Петербург" => { :locality => "Санкт-Петербург", :ctype => "город" },
    "193313, Санкт-Петербург, Искровский пр., 2, оф. 192" => { :index => 193313, :locality => "Санкт-Петербург", :thoroughfare => "Искровский проспект", :premise => "2", :office => "192" },
    "г.Новочебоксарск, ул. Винокурова, 48" => { :locality => "Новочебоксарск", :thoroughfare => "Винокурова" },
    "Чебоксары, ул. Текстильщиков, 10  (офис 109B)" => { :office => "109B" },
    "г. санкт-петербург, Белокрылого Орла ул., д. 50" => { :thoroughfare => "Белокрылого Орла", :ctype => "город", :premise => "50" }
  }
end
