require 'test_helper'
require 'application_helper'

class TelefonFederalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:telefon_federals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create telefon_federal" do
    assert_difference('TelefonFederal.count') do
      post :create, :telefon_federal => { }
    end

    assert_redirected_to telefon_federal_path(assigns(:telefon_federal))
  end

  test "should show telefon_federal" do
    get :show, :id => telefon_federals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => telefon_federals(:one).to_param
    assert_response :success
  end

  test "should update telefon_federal" do
    put :update, :id => telefon_federals(:one).to_param, :telefon_federal => { }
    assert_redirected_to telefon_federal_path(assigns(:telefon_federal))
  end

  test "should destroy telefon_federal" do
    assert_difference('TelefonFederal.count', -1) do
      delete :destroy, :id => telefon_federals(:one).to_param
    end

    assert_redirected_to telefon_federals_path
  end
end
