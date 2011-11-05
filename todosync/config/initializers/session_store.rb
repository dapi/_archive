# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_todosync_session',
  :secret      => '7b37304f43b05c7d345f4cfaed3b3d5e7ddaf764f2a1854a05a1e85b4a2c27c4dbd86fdcdad23c74648d260f558eb1818b314eb19d77607a36af13bb90074fed'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
