require 'test_helper'

class PlaceTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:place_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create place_type" do
    assert_difference('PlaceType.count') do
      post :create, :place_type => { }
    end

    assert_redirected_to place_type_path(assigns(:place_type))
  end

  test "should show place_type" do
    get :show, :id => place_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => place_types(:one).to_param
    assert_response :success
  end

  test "should update place_type" do
    put :update, :id => place_types(:one).to_param, :place_type => { }
    assert_redirected_to place_type_path(assigns(:place_type))
  end

  test "should destroy place_type" do
    assert_difference('PlaceType.count', -1) do
      delete :destroy, :id => place_types(:one).to_param
    end

    assert_redirected_to place_types_path
  end
end
