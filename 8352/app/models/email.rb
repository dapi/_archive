class Email < ActiveRecord::Base
  belongs_to :company

  validates_presence_of :email
  validates_format_of   :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  def to_s
    email
  end
end
