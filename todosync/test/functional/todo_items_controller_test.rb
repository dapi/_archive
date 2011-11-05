require 'test_helper'

class TodoItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => TodoItem.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    TodoItem.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    TodoItem.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to todo_item_url(assigns(:todo_item))
  end
  
  def test_edit
    get :edit, :id => TodoItem.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    TodoItem.any_instance.stubs(:valid?).returns(false)
    put :update, :id => TodoItem.first
    assert_template 'edit'
  end
  
  def test_update_valid
    TodoItem.any_instance.stubs(:valid?).returns(true)
    put :update, :id => TodoItem.first
    assert_redirected_to todo_item_url(assigns(:todo_item))
  end
  
  def test_destroy
    todo_item = TodoItem.first
    delete :destroy, :id => todo_item
    assert_redirected_to todo_items_url
    assert !TodoItem.exists?(todo_item.id)
  end
end
