# -*- coding: utf-8 -*-

# Given /^the following user_registrations:$/ do |user_registrations|
#   UserRegistration.create!(user_registrations.hashes)
# end

# When /^I delete the (\d+)(?:st|nd|rd|th) user_registration$/ do |pos|
#   visit user_registrations_path
#   within("table tr:nth-child(#{pos.to_i+1})") do
#     click_link "Destroy"
#   end
# end

# Then /^I should see the following user_registrations:$/ do |expected_user_registrations_table|
#   expected_user_registrations_table.diff!(tableish('table tr', 'td,th'))
# end


# Given "one visitor" do
#   @first_name = "my_first_name"
#   @email = "test@example.com"
# end

# Given "the visitor filled all the required fields" do
#   @params = {:user => {:first_name => @first_name, :email => @email}}
# end

# When "the visitor click signup button" do
#   # add this 3 lines for a startup
#   # make your delivery state to 'test' mode
#   ActionMailer::Base.delivery_method = :test
#   # make sure that actionMailer perform an email delivery
#   ActionMailer::Base.perform_deliveries = true
#   # clear all the email deliveries, so we can easily checking the new ones
#   ActionMailer::Base.deliveries.clear
#   post "/users", @params
# end

# Then "one new user created" do
#   @user = User.find_by_email(@email)
#   @user.should_not be_nil
# end

