require 'test_helper'

class StoragesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storage" do
    assert_difference('Storage.count') do
      post :create, :storage => { }
    end

    assert_redirected_to storage_path(assigns(:storage))
  end

  test "should show storage" do
    get :show, :id => storages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => storages(:one).to_param
    assert_response :success
  end

  test "should update storage" do
    put :update, :id => storages(:one).to_param, :storage => { }
    assert_redirected_to storage_path(assigns(:storage))
  end

  test "should destroy storage" do
    assert_difference('Storage.count', -1) do
      delete :destroy, :id => storages(:one).to_param
    end

    assert_redirected_to storages_path
  end
end
