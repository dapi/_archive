# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twit2sms_session',
  :secret      => '6fe32d854d2f5eb6587a75e1650ab4cb4dcf64768d7c0f3c99c6032acd77a90fc74ed8b212030f4f99dabacdc916b62130d61c4734c20487ae996d9c856ebb62'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
