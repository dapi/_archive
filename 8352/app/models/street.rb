class Street < ActiveRecord::Base
  has_many :premises
  has_many :addresses, :through=>:premises
#  has_many :companies, :through=>:premises, :source => :addresses
end
