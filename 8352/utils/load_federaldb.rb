#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'csv'
$KCODE = 'u'

prefix="78352"

CSV::Reader.parse(File.open(ARGV[0], 'rb')) do |row|
  (federal,city,operator)=row
  TelefonFederal.create(:federal=>federal,:city=>prefix+city, 
                       :operator=>operator)
end
