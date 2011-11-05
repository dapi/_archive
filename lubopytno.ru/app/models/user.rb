# -*- coding: utf-8 -*-

require 'digest/md5'
require 'username'

class User < ActiveRecord::Base
  enable_as_typus_user
  
  # Удаляем typus-овскую валидацию
  validates_presence_of.clear
  
  include Clearance::User
  
  acts_with_username

  attr_accessible :about, :phone
  
#  def email_confirmed?
#    self.status
#  end
  
  def has_role?(role)
    self.role
  end

end
