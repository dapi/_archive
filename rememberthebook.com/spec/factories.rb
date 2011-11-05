# -*- coding: utf-8 -*-
# Example http://snipplr.com/view/9350/factory-girl-example/



User.destroy_all
# Debt.destroy_all

Factory.define :user do |u| #, :default_strategy => :create
  u.sequence(:name) { |n| "user#{n}" }
  u.sequence(:email) { |n| "user#{n}@mail.com".downcase }
  u.password 'password'
  u.password_confirmation { |u| u.password }
end

Factory.define :virtual_user, :class=>User do |u| #, :default_strategy => :create
  u.email { |e| "#{e.name}@virtual.com".downcase }
end

Factory.define :creditor, :class=>User do |u| #, :default_strategy => :create
#  u.sequence(:name) { |n| "creditor#{n}" }
  u.sequence(:email) { |n| "creditor#{n}@creditor.com" }
  u.password 'password'
  u.password_confirmation 'password'
end


Factory.define :debtor, :class=>User do |u| #, :default_strategy => :create
#  u.sequence(:name) { |n| "debitor#{n}" }
  u.sequence(:email) { |n| "debitor#{n}@debtor.com" }
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :debt do |c|
  c.sequence(:thing) { |n| "The Thing in debt #{n}" }
  c.till Date.today + 7
  c.association :creditor
  c.association :debtor
end

Factory.define :credit do |c|
  c.sequence(:thing) { |n| "The Thing in credit #{n}" }
  c.till Date.today + 7
  c.association :creditor
  c.association :debtor
end





## Для has_many_emails

Factory.define :bob, :class=>User do |u| #, :default_strategy => :create
  u.sequence(:name) { |n| "bob#{n}" }
end

Factory.define :john, :class=>User do |u|
  u.sequence(:name) { |n| "john#{n}" }
end
