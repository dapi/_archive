require 'test_helper'

class TaggingTest < Test::Unit::TestCase
  should_belong_to :tag
  should_belong_to :taggable
end
