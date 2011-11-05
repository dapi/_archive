class Follow < ActiveRecord::Base
  belongs_to :user
  has_many :twits
  
  serialize  :twitter_fields, Mash

  attr_accessible :twitter

#  -----------------------------------------------------------------------------

  validates_presence_of   :twitter
  validates_uniqueness_of :twitter, :scope => :user_id, :case_sensitive => false
  validate :twitter_must_be_exist

#  -----------------------------------------------------------------------------

  def update_twitter
    twitter_fields = fetch_twitter
    self.update_attribute :twitter_fields, twitter_fields if twitter_fields
  end

  def update_twits
    require 'mash'

    response = HTTParty.get("http://twitter.com/statuses/user_timeline.xml?screen_name=#{self.twitter}")
    twitter_statuses =  Mash.new(response)
    last_twit = self.twits.last :order => :original_id
    last_twit_original_id = last_twit ? last_twit.original_id.to_i : 0

    twits = twitter_statuses.statuses.select{|s| s.id.to_i > last_twit_original_id }.collect do |status|
      { :message => status.text,
        :message_time => status.created_at,
        :original_id => status.id }
    end

    self.twits.create twits
  rescue
    false
  end

#  -----------------------------------------------------------------------------

  protected

  def twitter_must_be_exist
    errors.add(:twitter, " must be exist !") unless self.twitter_exist?
  end

  def twitter_exist?
    twitter_fields = fetch_twitter
    self.twitter_fields = twitter_fields if twitter_fields
  end

  def fetch_twitter
    twitter_user = Twitter.user(self.twitter)
    twitter_user && (not twitter_user.error) ? twitter_user : false
  rescue
    false
  end

end
