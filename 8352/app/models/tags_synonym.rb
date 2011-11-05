class TagsSynonym < ActiveRecord::Base
  belongs_to :tag
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
