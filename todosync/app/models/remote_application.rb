class RemoteApplication < ActiveRecord::Base
  
  has_many :todo_items
  
  validates_presence_of :name, :application_uid
  validates_uniqueness_of :application_uid, :token
  
  before_create :create_token
  
  def create_token
    self.token = encrypt("--#{Time.now.utc.to_s}--").first(12)
  end
  
  def encrypt(string)
    salt = generate_hash("--#{Time.now.utc.to_s}--salt--")
    generate_hash("--#{salt}--#{string}")
  end

  def generate_hash(string)
    Digest::SHA1.hexdigest(string)
  end

end
