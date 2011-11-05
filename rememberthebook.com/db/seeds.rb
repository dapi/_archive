# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#User.destroy_all
john = User.find_by_email('john@pismenny.ru') || User.create!(:name => 'John', :password=>'john', :password_confirmation=>'john',
                    :email => 'john@pismenny.ru')

bob = User.find_by_email('bob@pismenny.ru') || User.create!(:name => 'Bob',:email => 'bob@pismenny.ru')

john.credits.create(:thing=>"Gived to Bob thing", :debtor=>bob)
john.debts.create(:thing=>"Get from bob thing", :creditor=>bob)
bob.credits.create(:thing=>"Gived to John thing", :debtor=>john)
bob.debts.create(:thing=>"Get from John thing", :creditor=>john)
