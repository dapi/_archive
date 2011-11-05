class StreetsController < ApplicationController
  
  def show
    @street = Street.find params[:id]
    @premises = @street.premises
    companies_ids = @premises.all(:include => :companies).collect{|premise| premise.companies.collect{|company| company.id if company} }.flatten.compact.uniq
    @companies = Company.find_all_by_id(companies_ids).paginate :page => params[:page],
                        :per_page => configatron.companies_per_page
  end

end
