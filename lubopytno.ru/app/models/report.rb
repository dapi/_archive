class Report < ActiveRecord::Base
  belongs_to :place
  belongs_to :event

  before_save :set_place
  
protected
  
  def set_place
    self.place_id=event.place_id
  end

end
