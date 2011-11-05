class User < ActiveRecord::Base
  
  has_many :follows
  has_many :twits, :through => :follows

  accepts_nested_attributes_for :follows

  # new columns need to be added here to be writable through mass assignment
  #  attr_accessible :username, :email, :password, :password_confirmation
    
  attr_accessible :phone, :follows_attributes
  
  # attr_accessor :password
  before_validation :prepare_phone
  before_save       :generate_code

#  validates_associated    :follows
  validates_presence_of   :phone
  validates_uniqueness_of :phone
  validates_length_of     :phone, :minimum => 11
  validates_format_of     :phone, :with => /^7[0-9]+$/i,  :message => "should only contain numbers"
  
  named_scope :confirmed, :conditions => { :phone_confirmed => true }

  # validates_presence_of :username
  # validates_uniqueness_of :username, :email, :allow_blank => true
  # validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  # validates_presence_of :password, :on => :create
  # validates_confirmation_of :password
  # validates_length_of :password, :minimum => 4, :allow_blank => true
  
  # login can be either username or email address
  
#   def add_on_blank(attributes, custom_message = nil)
#     for attr in [attributes].flatten
#       value = @base.respond_to?(attr.to_s) ? @base.send(attr.to_s) : @base[attr.to_s]
#       add(attr, :blank, :default => custom_message) if value.blank?
#     end
#   end
#  

  def self.authenticate(phone, pass)

    user = find_by_phone(phone)# || find_by_email(login)
    if user && user.phone_code==pass
      user.confirm_phone unless user.phone_confirmed
      return user
    end

   end

  # def matching_password?(pass)
  #   self.password_hash == encrypt_password(pass)
  # end
  
#  def twitter
#    params[:user][:twitter]
#    'asdasd'
#  end
  
# protected
  
  def self.prepare_phone(phone)
    phone.gsub!(/[^0-9]/,'')
  end

  def prepare_phone
    User.prepare_phone(phone)
  end

  def generate_code
    # TODO Сделать нормальную генерацию кода
    # должно быть 5 цифр
    self.phone_code=rand(1000)
    send_code
  end

  def send_code
    send_sms("Ваш код регистрации: #{self.phone_code}")
  end

  def confirm_phone
    self.update_attribute('phone_confirmed',true)
  end

  def send_sms(text)
    SMS.send_sms(self.phone,text)
  end
  
  # def prepare_password
  #   unless password.blank?
  #     self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
  #     self.password_hash = encrypt_password(password)
  #   end
  # end
  
  # def encrypt_password(pass)
  #   Digest::SHA1.hexdigest([pass, password_salt].join)
  # end
end
