class TodoItemsController < ApplicationController
  def index
    @todo_items = TodoItem.all
  end
  
  def show
    @todo_item = TodoItem.find(params[:id])
  end
  
  def new
    @todo_item = TodoItem.new
  end
  
  def create
    @todo_item = TodoItem.new(params[:todo_item])
    if @todo_item.save
      flash[:notice] = "Successfully created todo item."
      redirect_to @todo_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @todo_item = TodoItem.find(params[:id])
  end
  
  def update
    @todo_item = TodoItem.find(params[:id])
    if @todo_item.update_attributes(params[:todo_item])
      flash[:notice] = "Successfully updated todo item."
      redirect_to @todo_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @todo_item = TodoItem.find(params[:id])
    @todo_item.destroy
    flash[:notice] = "Successfully destroyed todo item."
    redirect_to todo_items_url
  end
end
