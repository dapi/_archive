class Strelki < ActiveRecord::Base
  belongs_to :event
  belongs_to :place

  validates_presence_of :event
  
  before_create :set_place
  
  def set_place
    self.place_id=place.id
  end

end
