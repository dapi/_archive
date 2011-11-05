class SearchesController < ApplicationController

  def show
    @search_query = Sanitize.clean(params[:q])
    unless @search_query.blank?
      #ThinkingSphinx::Search.search(@query, :page => params[:page]).compact
      @companies = Company.search "*#{@search_query}*",
                                 :order => :name,
#                                 :limit => 1000,
                                 :page => params[:page],
                                 :per_page => configatron.companies_per_page,
                                 :excerpts => true
    end
  end

  def create
    redirect_to search_path :q => params[:q]
  end

end
