#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'csv'
$KCODE = 'u'

  # раздел, наименование, адрес, телефоны, веб-сайт, email, Время работы
CSV::Reader.parse(File.open(ARGV[0], 'rb')) do |row|
  (prefix,old,new)=row
  next if prefix=='префикс'
#  p prefix+old, prefix+new
  TelefonRename.create(:oldphone=>prefix+old,:newphone=>prefix+new, 
                       :rename_date=>'2009-04-01')
end
