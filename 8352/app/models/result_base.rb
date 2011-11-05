# -*- coding: utf-8 -*-
require "phone_parser"
require "address_parser"

class ResultBase < ActiveRecord::Base
  
  self.establish_connection :grabber
  set_table_name "results"

  serialize  :import_errors
  
  belongs_to :company, :counter_cache => true
  
  # belongs_to :result_category
  # has_one :category, :through=>:result_category

  belongs_to :source
  belongs_to :city

    
# ------------------------------------------------------------------------------
  state_machine :state, :initial => :updated do

    event :mark_imported do
      transition :updated => :imported
    end

    event :mark_updated do
      transition :imported => :updated
    end

  end

  # ------------------------------------------------------------------------------
  # Эти статусы имеют значение только если state=imported
  #
  # , :initial => nil
  state_machine :importer_state do
    
    before_transition [:fine,:partly,:pending]=>any,  :do => :mark_imported
    
    event :mark_none do
      transition all => :none
    end

    event :mark_fine do
      transition :prepared => :fine
    end

    event :mark_partly do
      transition :prepared => :partly
    end

    event :mark_prepared do
      transition :none => :prepared
    end

    event :mark_pending do
      transition :prepared => :pending
    end

    event :mark_error do
      transition :prepared => :error
    end

  end
# ------------------------------------------------------------------------------

  

  # Обновленные
  named_scope :updated, { 
    :conditions => { :state => 'updated' },
    :order => :id 
  }
  
  # Готовые к имортированую (все для кого установлены категории
  named_scope :importable, lambda  { |source_id|
    { 
#      :include => :result_category,
      :conditions => ["state='updated' and results.source_id=? and company_group_id is not null",
                      source_id],
      :order => :id
    }
  }

  named_scope :imported, lambda  { |source_id|
    { 
      
      :conditions => ["state='imported' and results.source_id=?",source_id],
    }
  }

  
  # для typus
  
  def self.importer_state
    ['none','prepared','fine','partly','pending','error']
  end

  def self.state
    ['updated','imported']
  end

  
end
