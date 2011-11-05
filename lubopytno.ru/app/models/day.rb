class Day < ActiveRecord::Base
  has_many :events
  
  validates_presence_of :date
  validates_uniqueness_of :date
  
  def self.lenta_events
  end
  
  def lenta_events
    events
  end
  
end
