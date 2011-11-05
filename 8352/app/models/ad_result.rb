# -*- coding: utf-8 -*-
#require "phone_parser"
#require "address_parser"

class AdResult < ResultBase
  
  set_table_name "ad_results"
  
  belongs_to :ad_result_category
  #has_one :category, :through=>:result_category

#  include PhoneHelper
  #  extend ActiveSupport::Memoizable

  serialize :fields, Hash


  
end
