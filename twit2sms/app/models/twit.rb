class Twit < ActiveRecord::Base
  named_scope :not_sended, :conditions => { :sent_at => nil }
end
