class Notifier < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  
  def password_reset_instructions(user)
    subject "Password Reset Instructions"
    from "Develon Notifier <noreply@develon.com>"
    recipients user.email
    sent_on Time.now
    body :edit_password_reset_url => password_reset_url(user.perishable_token)
  end

  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "Develon Notifier <noreply@develon.com>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          "Develon Notifier <noreply@develon.com>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end
end