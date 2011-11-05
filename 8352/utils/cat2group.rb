#!/usr/bin/ruby
require  File.dirname(__FILE__) + '/../config/environment'
require 'pp'

ResultCategory.all.map { |c|
  cat=Category.find(c.category_id)
  if cat
    p cat.name
    group=CompanyGroup.find_by_name(cat.name)
    if group
      h={:category_name=>c.category_name,
        :source_id=>c.source_id,
        :company_group_id=>group.id}
      
      ResultsToCompanyGroup.create!(h) unless ResultsToCompanyGroup.first(:conditions=>h)
      
    else
      raise "!!! No #{cat.name} group found"
      end
  else
    raise "!!! No #{c.category_id} category found"
  end
}
