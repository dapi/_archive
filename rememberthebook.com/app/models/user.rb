# -*- coding: utf-8 -*-


class User < ActiveRecord::Base
  
  require 'user/providers'
  require 'user/contacts'
  require 'user/merge'
  require 'user/password'
  require 'user/notifications'

  attr_protected :role
  
  devise :token_authenticatable, :database_authenticatable, #, :oauthable,
  :registerable, :recoverable, :rememberable, :trackable,
  :omniauthable,  :omniauth_providers => [:twitter, :google_open_id, :facebook, :open_id] #, :vkontakte_open_api

  serialize :facebook_data

  
  # Должно быть до валидации
  normalize_attributes :email, :name, :open_id_uid

  validates :open_id_uid, :uniqueness=>{ :allow_nil=>true }
  validates :facebook_uid, :uniqueness=>{ :allow_nil=>true }
  validates :twitter_uid, :uniqueness=>{ :allow_nil=>true }

  has_many :contacts, :dependent=>:destroy
  

  # Выступил как дебитор, то есть его долги (то что взял)
  has_many :debts, :foreign_key => :debtor_id, :dependent=>:destroy 
  
  # Выступил как кредитор, то есть его кредиты (то что он отдал взаймы)
  has_many :credits, :foreign_key => :creditor_id, :dependent=>:destroy 
  has_many_emails
    

  # include User::Providers
  include User::Contacts, User::Merge, User::Password, User::Notifications


  before_save :set_normal
  before_create :set_nopass
  before_create :ensure_authentication_token
  after_create :send_registration

 
  # Для typus-а
  STATE =  [:normal, :nopass, :virtual ]

  state_machine :initial => :normal do
    # nopass - чувак зарегился без пароля
    # virtual - зарегистрировали партнеры, когда оформляли долг/кредит
    state *STATE
  end

  def to_s
    return attributes["name"] if name?
    unless email?
      if open_id_uid
        u = URI.parse(open_id_uid)
        return u.host + (u.path=='/' ? '' : u.path)
      else
        return 'Anomymous'
      end
    end
    n = /^(.*)\@/.match(email)[1]
    n[0]=n.first.upcase
    return "#{n} (#{email})"
  end

  def to_label
    to_s
  end

  def email_to
    # TODO Escape name здесь и далее
    name? ? "#{name} <#{email}>" : email
  end

  def is_root?
    role == 'admin' # Typus.master_role
  end


  def set_nopass
    self.state = 'nopass'  if normal? && password.blank?
    true
  end

  def set_normal
    self.state = 'normal'  if password.present? && password==password_confirmation
    true
  end


  def email_required?
    false # TODO
  end


end
