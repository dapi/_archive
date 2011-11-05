# -*- coding: undecided -*-

Then /^I am redirected to "([^\"]*)"$/ do |url|
  # Не рботает, статус не устанавливается
  assert [301, 302].include?(@integration_session.status), "Expected status to be 301 or 302, got #{@integration_session.status}"
  location = @integration_session.headers["Location"]
  assert_equal url, location
  visit location
end

Then /^let me to debug$/ do
    debugger
end
