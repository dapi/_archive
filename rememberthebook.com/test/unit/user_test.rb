require 'test_helper'

class UserATest < ActiveSupport::TestCase
  def test_should_be_valid
    assert User.new(:email=>'danil@orionet.ru',:is_virtual=>true).valid?
  end

end

