#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment.rb'
require File.dirname(__FILE__) + '/../lib/acts_as_taggable.rb'
#require 'active_support'
#require 'action_controller'

#require 'fileutils'
#require 'optparse'
require 'csv'
#ENV['RAILS_ENV']='development'
$KCODE = 'u'

old_cat=nil
category=nil
  # раздел, наименование, адрес, телефоны, веб-сайт, email, Время работы
CSV::Reader.parse(File.open(ARGV[0], 'rb')) do |row|
  (cat,name,address,tels,site,email,work_time,comment)=row
  next if cat=='Раздел'
  unless cat.nil?
#    category.save unless old_cat.nil?
    old_cat=cat
    category=Category.new(:name=>cat,:description=>cat)
    raise 'cant create category' unless category.save
 #   p category
  end
  company=category.companies.create(:name=>name,:full_name=>name,
                      :address=>address,:site=>site,
                      :description=>comment)
  
  raise 'cant create company' unless company.save
  if tels!=nil
    p=/(\d+)\s*(\((.+)\))?/
    filials = tels.split(",")
#    print tels
    filials.each do |f|
      f=f.sub(/^\s+/,'')
      refs=p.match(f).to_a
      number=refs[1]
      dep=refs[3]
      number=f.sub(/\s+$/,'')
        #      p refs
        if number=~/^8/
          if number.length==11
            number=number.sub(/^8/,'7')
          else
            number="7#{number}"
          end
        else
          number="78352#{number}"
        end
      number=number.to_i
      unless number==78352
        phone=company.phones.new(:number=>number,:department=>dep)
        unless phone.save
          p phone.errors
          raise 'cant create phone'
        end
      end
    end
  end
  if email!=nil
    e=company.emails.new(:email=>email) #,:person=>'',:department=>''
    raise 'cant create email' unless e.save
    
  end


end
