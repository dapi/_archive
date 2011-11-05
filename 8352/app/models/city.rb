# -*- coding: utf-8 -*-
class City < ActiveRecord::Base
  
  CTYPES=['город','село','поселок','деревня']


  
  has_many :companies
  
  validates_presence_of :name, :prefix, :ctype
  validates_uniqueness_of  :name
  validates_format_of   :prefix, :with => /^7\d\d\d+$/
  validates_inclusion_of :ctype, :in => CTYPES
  
#  before_save :capitalize_name
 
  # TODO Делать капитализе только для названия
#  def capitalize_name
#    self.name=self.name.mb_chars.capitalize.to_s
#  end
  
  def self.ctype 
    CTYPES
  end
  
  
  
end
