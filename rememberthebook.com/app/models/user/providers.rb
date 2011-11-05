# -*- coding: utf-8 -*-

module User::Providers

  def self.included(base)
    base.extend ClassMethods
  end
  
  
  def is_provider_linked?( provider )
    ! provider_uid(provider).blank?
  end

  def provider_uid( provider )
    read_attribute self.class.provider_uid_attr( provider )
  end
  
  def update_by_omniauth(data)
    new_email = self.class.extract_email_from_omniauth data
    h = {}
    h[:name] = data["user_info"]["name"] unless name?

    # TODO Объединять юзеров если такие уже есть
    h[:email] = new_email if email.blank? && new_email.present? && !User.find_by_email( new_email )
    h[ self.class.provider_uid_attr(data) ] = data["uid"] unless provider_uid( data )

    update_attributes h unless h.empty?
    add_email email if new_email.present? && !has_email?( new_email) && !User.find_by_email( new_email )
    save
    self
  end
  


  module ClassMethods
    
    def provider_uid_attr(provider)
      provider = provider["provider"] if provider.is_a? Hash
      "#{provider}_uid".to_sym
    end
  
    def extract_email_from_omniauth( data )
      email = data['user_info']['email'] || (data['extra'] && data['extra']['user_hash'] ?  data['extra']['user_hash']['email'] : nil)
    end

    def find_for_omniauth(data, signed_in_resource=nil)
      if user =  User.find_for_authentication({ User.provider_uid_attr(data) => data["uid"] })
        return user.update_by_omniauth( data )
      end

      email = extract_email_from_omniauth data
      user =  User.find_by_email( email ) unless email.blank?

      user = signed_in_resource || User.new unless user
      user.update_by_omniauth( data )
    end


    def find_for_authentication(conditions)
      if conditions.has_key? :email
        find_by_email( conditions[:email] )
      else
        super conditions
      end
    end


  end


end

