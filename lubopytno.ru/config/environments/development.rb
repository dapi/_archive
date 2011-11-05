# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false
#config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
config.action_mailer.delivery_method = :test

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.i18n.default_locale = :ru

config.gem "ya2yaml"


config.gem "cucumber",    :lib => false,        :version => ">=0.3.11" unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber'))
config.gem "webrat",      :lib => false,        :version => ">=0.4.4" unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))
#config.gem "rspec",       :lib => false,        :version => ">=1.2.6" unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
#config.gem "rspec-rails", :lib => 'spec/rails', :version => ">=1.2.6" unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))

config.gem 'thoughtbot-factory_girl', :lib     => 'factory_girl',
  :source  => "http://gems.github.com", 
  :version => '1.2.1'


config.gem "yaroslav-russian",
:lib     => 'russian', 
:source  => 'http://gems.github.com'




HOST = "localhost"
DO_NOT_REPLY = "notreply@localhost"
