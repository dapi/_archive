require 'test_helper'

class EmailTest < Test::Unit::TestCase
  should_belong_to :company

  should_validate_presence_of :email
end