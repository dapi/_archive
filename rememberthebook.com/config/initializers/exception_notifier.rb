
if MAIL_CONFIG[:exception_notifier].present?
  
  Rtb::Application.configure do
  # Configure ExceptionNotifier plugin
    config.middleware.use ::ExceptionNotifier,
    :email_prefix => "[RTB Exception] ",
    :sender_address => MAIL_CONFIG[:exception_notifier]["sender"],
    :exception_recipients => MAIL_CONFIG[:exception_notifier]["recipient"]
  end
  
end
