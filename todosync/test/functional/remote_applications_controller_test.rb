require 'test_helper'

class RemoteApplicationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => RemoteApplication.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    RemoteApplication.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    RemoteApplication.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to remote_application_url(assigns(:remote_application))
  end
  
  def test_edit
    get :edit, :id => RemoteApplication.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    RemoteApplication.any_instance.stubs(:valid?).returns(false)
    put :update, :id => RemoteApplication.first
    assert_template 'edit'
  end
  
  def test_update_valid
    RemoteApplication.any_instance.stubs(:valid?).returns(true)
    put :update, :id => RemoteApplication.first
    assert_redirected_to remote_application_url(assigns(:remote_application))
  end
  
  def test_destroy
    remote_application = RemoteApplication.first
    delete :destroy, :id => remote_application
    assert_redirected_to remote_applications_url
    assert !RemoteApplication.exists?(remote_application.id)
  end
end
