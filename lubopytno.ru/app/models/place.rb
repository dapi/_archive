class Place < ActiveRecord::Base
  belongs_to :place_type #, :counter_cache => true
  has_many :events
  
  validates_presence_of :name
end
