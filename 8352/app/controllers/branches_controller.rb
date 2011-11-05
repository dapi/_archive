class BranchesController < ApplicationController

  access_control do
     allow all
  end
  
  def show
    @branch = Branch.find params[:id]
    @company_groups = @branch.groups

    @companies = @branch.companies.paginate :page => params[:page], :per_page => configatron.companies_per_page
  end

  def index
    @page_title = 'Все категории'
    @branch_roots = Branch.roots.all :order => :name
  end
end
