APP_CONFIG = YAML.load(File.read(File.expand_path("../../config/app_config.yml", __FILE__)))[Rails.env].symbolize_keys

MAIL_CONFIG = APP_CONFIG[:mail].symbolize_keys
MAIL_CONFIG[:notifier] = MAIL_CONFIG[:notifier].symbolize_keys
MAIL_CONFIG[:smtp] = MAIL_CONFIG[:smtp].symbolize_keys

TWITTER_CONFIG = APP_CONFIG[:twitter].symbolize_keys
VKONTAKTE_CONFIG = APP_CONFIG[:vkontakte].symbolize_keys
FACEBOOK_CONFIG = APP_CONFIG[:facebook].symbolize_keys
