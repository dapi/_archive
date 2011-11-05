# -*- coding: utf-8 -*-
module ActsWithUsername
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  
  module ClassMethods
    def acts_with_username
      
      extend ClassMethodsMixin
  
      attr_accessible :username
  
      # TODO только латиница, цифры, дефис, подчекивание и тире
      validates_format_of   :username, :with => %r{[a-zA-Z0-9_\-.]+}
      validates_presence_of :username
      validates_uniqueness_of :username
      
      before_save :downcase_email
  
      include InstanceMethods

    end
  end
  
  module ClassMethodsMixin
    
    def authenticate(email, password)
      user = find(:first, :conditions => ['username = ? OR email = ?', email.to_s.downcase, email.to_s.downcase])
      user && user.authenticated?(password) ? user : nil
    end
    
  end
  
  module InstanceMethods
    
    def authenticated?(pw)
      
      # Если не указан salt, значит это старый пользовать из жажды
      # у которого пароль записан в md5 без salt.
      # zhazhda_user
      unless salt
        return unless encrypted_password == Digest::MD5.hexdigest(pw)
        self.password=pw
        self.salt = generate_hash("--#{Time.now.utc.to_s}--#{pw}--")
        save
      end
      super
    end

      
    def downcase_email
      self.email = email.to_s.downcase
    end

    
  end
end

ActiveRecord::Base.send :include, ActsWithUsername
