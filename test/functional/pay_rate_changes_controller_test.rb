require 'test_helper'

class PayRateChangesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pay_rate_changes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pay_rate_change" do
    assert_difference('PayRateChange.count') do
      post :create, :pay_rate_change => { }
    end

    assert_redirected_to pay_rate_change_path(assigns(:pay_rate_change))
  end

  test "should show pay_rate_change" do
    get :show, :id => pay_rate_changes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pay_rate_changes(:one).to_param
    assert_response :success
  end

  test "should update pay_rate_change" do
    put :update, :id => pay_rate_changes(:one).to_param, :pay_rate_change => { }
    assert_redirected_to pay_rate_change_path(assigns(:pay_rate_change))
  end

  test "should destroy pay_rate_change" do
    assert_difference('PayRateChange.count', -1) do
      delete :destroy, :id => pay_rate_changes(:one).to_param
    end

    assert_redirected_to pay_rate_changes_path
  end
end
