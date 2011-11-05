require 'test_helper'

class PhoneTest < Test::Unit::TestCase
  should_belong_to :company

  should_validate_presence_of :number
  should_validate_numericality_of :number
end