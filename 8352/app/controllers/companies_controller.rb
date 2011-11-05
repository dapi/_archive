class CompaniesController < ApplicationController

  access_control do
     allow all
  end

  def index
    @companies = params[:category_id] ?
    Company.find_all_by_category_id(params[:category_id]) :
      Company.find(:all,:limit=>50)
  end

  def show
    @company = Company.find(params[:id])
  end
  
  def new
    @company = Company.new
    @company.phones.build
    @company.emails.build
    @category = Category.find(params[:category_id])
    @company.category_id = params[:category_id]
  end
  
  def create
    @company = Company.new(params[:company])
    @company.category_id = params[:category_id]
    
    if @company.save
      flash[:notice] = 'Компания была создана и будет доступна после одобрения изменений админстратором.'
      redirect_to categories_url
    else
      render :action
    end
  end
  
  def edit
    # TODO секьюрити ахтунг !
    @company = Company.find(params[:id])
  end
  
  def update
    # TODO секьюрити ахтунг !
    @company = Company.find(params[:id])
    @company.dump_attributes
    params[:company][:pending] = true

    if @company.update_attributes(params[:company])
      flash[:notice] = 'Компания была изменена и будет доступна после одобрения изменений админстратором.'
      redirect_to categories_url
    else
      render :action => "edit"
    end
  end
  
end
