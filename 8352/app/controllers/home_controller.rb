class HomeController < ApplicationController

  access_control do
     allow all
  end
  
  def index
    @company_branches = Branch.roots.all :order => :name
    @premises = Premise.all :conditions => "premises.number IS NOT NULL",
                            :joins => :street,
                            :include => :street,
                            :order => "streets.name asc, premises.number asc"
                          
    @streets = Street.all :order => :name
  end

end
