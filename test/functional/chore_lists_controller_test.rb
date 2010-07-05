require 'test_helper'

class ChoreListsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chore_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chore_list" do
    assert_difference('ChoreList.count') do
      post :create, :chore_list => { }
    end

    assert_redirected_to chore_list_path(assigns(:chore_list))
  end

  test "should show chore_list" do
    get :show, :id => chore_lists(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => chore_lists(:one).id
    assert_response :success
  end

  test "should update chore_list" do
    put :update, :id => chore_lists(:one).id, :chore_list => { }
    assert_redirected_to chore_list_path(assigns(:chore_list))
  end

  test "should destroy chore_list" do
    assert_difference('ChoreList.count', -1) do
      delete :destroy, :id => chore_lists(:one).id
    end

    assert_redirected_to chore_lists_path
  end
end
