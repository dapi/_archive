class Premise < ActiveRecord::Base
  belongs_to :street
  has_many :addresses
  has_many :companies, :through => :addresses
end
