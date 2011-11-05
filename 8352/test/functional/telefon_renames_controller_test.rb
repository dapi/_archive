require 'test_helper'

class TelefonRenamesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:telefon_renames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create telefon_rename" do
    assert_difference('TelefonRename.count') do
      post :create, :telefon_rename => { }
    end

    assert_redirected_to telefon_rename_path(assigns(:telefon_rename))
  end

  test "should show telefon_rename" do
    get :show, :id => telefon_renames(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => telefon_renames(:one).to_param
    assert_response :success
  end

  test "should update telefon_rename" do
    put :update, :id => telefon_renames(:one).to_param, :telefon_rename => { }
    assert_redirected_to telefon_rename_path(assigns(:telefon_rename))
  end

  test "should destroy telefon_rename" do
    assert_difference('TelefonRename.count', -1) do
      delete :destroy, :id => telefon_renames(:one).to_param
    end

    assert_redirected_to telefon_renames_path
  end
end
