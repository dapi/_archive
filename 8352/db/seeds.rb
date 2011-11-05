# # Remove old
# p "1. delete_all from roles, users, roles_users"

# Role.delete_all
# RolesUser.delete_all
# User.delete_all

# # Add default roles
# p "2. add default roles"
# Role.create [{ :name => 'admin' }, { :name => 'moderator' }, { :name => 'user' }]

# p "3. add default users: admin, moderator, user"
# # Add default admin
# user = User.create :email => 'admin@domain.abc',
#                    :password => 'admin123',
#                    :password_confirmation => 'admin123'
# user.activate!
# user.has_role! :admin

# # Add default moderator
# user = User.create :email => 'moderator@domain.abc',
#                    :password => 'moderator123',
#                    :password_confirmation => 'moderator123'
# user.activate!
# user.has_role! :moderator

# # Add default user
# user = User.create :email => 'user@domain.abc',
#                    :password => 'user123',
#                    :password_confirmation => 'user123'
# user.activate!
# user.has_role! :user

p "4. add streets to DB"
# Streets
File.open("#{RAILS_ROOT}/doc/streets.txt", "r") do |file|
  file.each do |line|
    Street.find_or_create_by_name line.mb_chars.strip.to_s
  end
end

p "5. make premises from addresses"
# Make premises from addresses
Premise.delete_all
Address.all.each{|a| a.update_premise }
