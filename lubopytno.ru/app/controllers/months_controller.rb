class MonthsController < ApplicationController
  
  layout 'lean'
  
  def index
    @months = Month.all
  end
    
  def show
    
    if params[:id]=~/_/
      
      a,b = params[:id].split('_')
      
      list = Month.list_from_to(a,b)
      
      respond_to do |format|
        format.html { raise "no such render" }
        format.json { render :partial => 'lenta/months', :locals=>{:months=>list} }
      end

      
    else
      
      @month = Month.find(params[:id])
    
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :partial => 'lenta/month', :locals=>{:month=>@month} }
      end
      
    end

  end
  
  def new
    @month = Month.new
  end
  
  def create
    @month = Month.new(params[:month])
    if @month.save
      flash[:notice] = "Successfully created month."
      redirect_to @month
    else
      render :action => 'new'
    end
  end
  
  def edit
    @month = Month.find(params[:id])
  end
  
  def update
    @month = Month.find(params[:id])
    if @month.update_attributes(params[:month])
      flash[:notice] = "Successfully updated month."
      redirect_to @month
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @month = Month.find(params[:id])
    @month.destroy
    flash[:notice] = "Successfully destroyed month."
    redirect_to months_url
  end
end
