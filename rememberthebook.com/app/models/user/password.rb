# -*- coding: utf-8 -*-

module User::Password

  def self.included(base)
    # base.extend ClassMethods
    # assert_validations_api!(base)
    password_length = 5..60
    base.class_eval do
      validates_presence_of   :email, :if => :email_required?
      
      # validates_uniqueness_of :email, :scope => authentication_keys[1..-1], :case_sensitive => false, :allow_blank => true
      # validates_format_of     :email, :with  => email_regexp, :allow_blank => true
      
      with_options :if => :password_required? do |v|
        v.validates_presence_of     :password
        v.validates_confirmation_of :password
        v.validates_length_of       :password, :within => password_length, :allow_blank => true
      end
    end
  end

  
  def valid_password?(password)
     #  TODO patch на devise?
     # А то иначе при логине виртуала BCrypt отваливается с invalid hash
     return false unless self.encrypted_password.present?
     ::BCrypt::Password.new(self.encrypted_password) == "#{password}#{self.class.pepper}"
   end


  def update_with_password(params={})
    current_password = params.delete(:current_password)
    
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end    
    
    result = update_attributes( params )
    clean_up_passwords
    result
  end

protected

   # Редактируем профиль без предоставления пароля #new_record? ||
   # Не спрашиваем пароль при регистрации виртуалов
  def password_required?
    !new_record? && (password.present? || password_confirmation.present?)
  end

end
