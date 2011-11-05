class AdminUser < User
#  accessible_attributes.clear
  attr_accessible :role, :status, :email_confirmed, :phone_confirmed
  
end
