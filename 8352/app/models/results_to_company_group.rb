# -*- coding: utf-8 -*-
class ResultsToCompanyGroup < ActiveRecord::Base
    
  self.establish_connection :grabber
  
#  acts_as_taggable
  
  belongs_to :company_group
  belongs_to :source

  has_many :results, :foreign_key=>:category_name, :primary_key=>:category_name, :conditions => 
    { 
    :source_id=>'#{source_id}'
  }

  has_many :imported_results, :foreign_key=>:category_name, :primary_key=>:category_name, :class_name=>'Result', :conditions => 
    { 
    :state=>'imported', 
    :source_id=>'#{source_id}'
  }
    
  validates_uniqueness_of :category_name, :case_sensitive=>false, :scope => [:source_id]
  validates_presence_of :category_name

  after_save :update_results
#  before_destroy :update_results
  
  # TODO Проверять на обязательное присутствие одного из primary тэгов
  # или, может быть, на один из тэгов присутствующий в category
  
  def name
    self.category_name
  end

  def update_companies
    imported_results.map { |r|
      r.company.company_group=company_group
      r.company.save!
 #     r.company.update_attribute(:company_group_id,company_group_id)
    }
  end
  
  def update_results
     Result.
       update_all({
                    :company_group_id=>self.company_group_id,
                  },
                  {
                    :category_name=>self.category_name,
                    :source_id=>self.source_id
                  })
  end
  

end
