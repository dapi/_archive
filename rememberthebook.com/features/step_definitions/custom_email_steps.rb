# http://github.com/bmabey/email-spec
# http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/


Then "the new user should receive an email confirmation" do
  # this will get the first email, so we can check the email headers and body.
  @email = ActionMailer::Base.deliveries.first
  # @email.from.should == "admin@example.com"
  @email.to.should == @user.email
  @email.body.should include("some key word or something....")
end


Then /^show me the mail$/ do 
  filename = EmailSpec::EmailViewer::tmp_email_filename
  File.open(filename, "w") do |f|
    f.write current_email.subject #decoded
    f.write current_email.decode_body #decoded
  end
  open_in_browser( filename )
end


def open_in_browser(path) # :nodoc
  require "launchy"
  Launchy::Browser.run(path)
rescue LoadError
  warn "Sorry, you need to install launchy to open pages: `gem install launchy`"
end
