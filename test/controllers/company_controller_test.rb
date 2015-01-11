require 'test_helper'

class CompanyControllerTest < ActionController::TestCase
  test "should get add" do
    get :add
    assert_response :success
  end

  test "should get edit_profile" do
    get :edit_profile
    assert_response :success
  end

  test "should get locations" do
    get :locations
    assert_response :success
  end

  test "should get services" do
    get :services
    assert_response :success
  end

  test "should get location" do
    get :location
    assert_response :success
  end

end
