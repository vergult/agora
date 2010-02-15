# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_agora_session',
  :secret      => '1526ea917ef76b8ce307c29ffcbd47e2af49d96c6127c80f1af55f51576f0cd876412d3272d70f583fb64fe2cdf7aaf0b5c14d79c248442bb17b286a761fb7b5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
