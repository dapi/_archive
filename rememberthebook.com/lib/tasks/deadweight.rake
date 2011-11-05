begin
  require 'deadweight'
rescue LoadError
end

desc "run Deadweight CSS check (requires script/server)"
task :deadweight=>:environment do
  dw = Deadweight.new
  dw.stylesheets = ["/stylesheets/compiled/screen.css"]
  dw.mechanize = true

  dw.pages = ["/", "/users/sign_up", "/users/password/new"]  # "/users/sign_in",
  
  john = User.find_by_email('john@pismenny.ru')
  
  dw.pages << proc {
    fetch('/users/sign_in')
    form = agent.page.forms.first
    
    form["user[email]"] = john.email
    form["user[password]"] = 'john'
    agent.submit(form)
    fetch("/credits")
  }

  dw.pages += [
               "/debts/#{john.debts.first.id}",
               "/contacts", "/contacts/#{john.contacts.first.id}",
               "/credits/#{john.credits.first.id}",
               "/credits/new", "/debts/new", "/users/edit"
              ]

  dw.ignore_selectors = /formtastic|flash_|errorExplanation|fieldWithErrors|error_messages|notify-bar|flashes/
  puts dw.run
end
