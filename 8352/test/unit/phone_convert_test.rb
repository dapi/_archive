require 'test/unit'
require File.dirname(__FILE__) + '/../../config/environment.rb'
#require 'app/helpers/phone_helper'
#require 'app/models/telefon_rename'
#require 'app/models/telefon_federal'
include PhoneHelper
#include TelefonRename
#include TelefonFederal

#require 'rubygems'
#require 'mocha'

class NormalizePhoneText < Test::Unit::TestCase
  
  # def test_rename
  #   phone="88352721617"
  #   assert_equal "78352771617", PhoneHelper::normalize_phone(phone)
  # end

  # def test_extend_and_rename
  #   phone="421414"
  #   assert_equal "78352581414", PhoneHelper::normalize_phone(phone)
  # end

  # def test_extend_and_rename2
  #   phone="495117"
  #   assert_equal "78352405117", PhoneHelper::normalize_phone(phone)
  # end

  # def test_extend_and_no_modification
  #   phone="431414"
  #   assert_equal "78352431414", PhoneHelper::normalize_phone(phone)
  # end
  
  # def test_mobile
  #   assert_equal "79023270019", PhoneHelper::normalize_phone("670019")
  # end

  # def test_mobile2
  #   assert_equal "79023270022", PhoneHelper::normalize_phone("9023270022")
  # end

  # def test_mobile3
  #   assert_equal "79083016702", PhoneHelper::normalize_phone("466702")
  # end

  # def test_dirty_number
  #   assert_equal "79083016702", PhoneHelper::normalize_phone("46-67-02")
  # end

  # def test_dirty_number2
  #   assert_equal "79023270017", PhoneHelper::normalize_phone("(902) 327-00-17")
  # end

end
