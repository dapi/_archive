class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :day
  belongs_to :place

  validates_presence_of :day_id, :subject, :event_type_id, :place_id
  
  before_save :set_date

 protected
  
  def set_date
    self.date=day.date
  end
end
