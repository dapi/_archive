class Link < ActiveRecord::Base
  belongs_to :source
  has_many :results

#  named_scope :appeared, { :conditions => { :is_appeared => true } }

  #acts_as_tree :order => "name", :counter_cache => :links_count
end
