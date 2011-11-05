class ResultsController < ApplicationController

  def index
    @company = Company.find params[:company_id]
    @results = @company.results
  end
  
end
