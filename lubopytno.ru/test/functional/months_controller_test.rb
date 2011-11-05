require 'test_helper'

class MonthsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Month.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Month.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Month.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to month_url(assigns(:month))
  end
  
  def test_edit
    get :edit, :id => Month.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Month.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Month.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Month.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Month.first
    assert_redirected_to month_url(assigns(:month))
  end
  
  def test_destroy
    month = Month.first
    delete :destroy, :id => month
    assert_redirected_to months_url
    assert !Month.exists?(month.id)
  end
end
