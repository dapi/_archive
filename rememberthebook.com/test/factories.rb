Factory.define :user do |u| #, :default_strategy => :create
  u.name 'user1'
  u.email { |e| "#{e.name}@mail.me".downcase }
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :admin, :class=>User do |u| #, :default_strategy => :create
  u.name 'admin'
  u.role 'admin'
  u.email { |e| "#{e.name}@mail.me".downcase }
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :creditor, :class=>User do |u| #, :default_strategy => :create
  u.name 'creditor'
  u.email { |e| "#{e.name}@mail.me".downcase }
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :debtor, :class=>User do |u| #, :default_strategy => :create
  u.name 'debtor'
  u.email { |e| "#{e.name}@mail.me".downcase }
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :credit do |c|
  c.thing 'Thing1'
  c.till Date.today
  c.association :creditor, :factory => :creditor
  c.association :debtor, :factory => :debtor
#  u.debtor = Factory :user, :name => 'user2'
end

Factory.define :debt do |c|
  c.thing 'Thing1'
  c.till Date.today
  c.association :creditor, :factory => :debtor
  c.association :debtor, :factory => :creditor
end


