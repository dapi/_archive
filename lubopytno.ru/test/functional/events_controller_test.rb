require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => { :day_id=>1, :subject=>'test event', :event_type_id=>1, :place_id=>1 }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, :id => events(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => events(:one).to_param
    assert_response :success
  end

  test "should update event" do
    put :update, :id => events(:one).to_param, :event => { }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, :id => events(:one).to_param
    end

    assert_redirected_to events_path
  end
end
