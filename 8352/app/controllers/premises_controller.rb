class PremisesController < ApplicationController

  def show
    @premise = Premise.find params[:id]
    @companies = @premise.companies.paginate :page => params[:page], :per_page => configatron.companies_per_page
    @companies.uniq!
  end
  
end
