require 'spec_helper'

describe Contact do

  should_belong_to :partner
  should_belong_to :user

  should_validate_presence_of :partner
  should_validate_presence_of :user

end
