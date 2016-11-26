require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @user = users(:reg_user)
    @admin = users(:admin)
  end

  test 'should redirect new as unauth' do
    get :new
    assert_response :redirect
  end

  test 'should redirect new as regular user' do
    log_in(@user)
    get :new
    assert_response :redirect
  end

  test 'should get new as admin' do
    log_in(@admin)
    get :new
    assert_response :success
  end

  test 'should redirect index as unauth' do
    get :index
    assert_response :redirect
  end

  test 'should redirect index as regular user' do
    log_in(@user)
    get :index
    assert_response :redirect
  end

  test 'should get index as admin' do
    log_in(@admin)
    get :index
    assert_response :success
  end

  test 'should redirect show as unauth' do
    get :show, params: { id: @user.id }
    assert_response :redirect
  end

  test 'should redirect show as regular user' do
    log_in(@user)
    get :show, params: { id: @user.id }
    assert_response :redirect
  end

  test 'should get show as admin' do
    log_in(@admin)
    get :show, params: { id: @user.id }
    assert_response :success
  end

  test 'should redirect edit as unauth' do
    get :edit, params: { id: @user.id }
    assert_redirected_to root_path
  end

  test 'should redirect edit as regular user' do
    log_in(@user)
    get :edit, params: { id: @user.id }
    assert_redirected_to root_path
  end

  test 'should get edit as admin' do
    log_in(@admin)
    get :edit, params: { id: @user.id }
    assert_response :success
  end

  test 'invalid update should fail' do
    log_in(@admin)
    post :update, params: { id: @user.id, user: { name: '' } }
    assert_response :success
  end

  test 'valid update should succeed' do
    log_in(@admin)
    post :update, params: { id: @user.id, user: { name: 'hodor' } }
    assert_redirected_to user_path(@user)
  end

  test 'should redirect destroy as unauth' do
    delete :destroy, params: { id: @user.id }
    assert_redirected_to root_path
  end

  test 'should redirect destroy as regular user' do
    log_in(@user)
    delete :destroy, params: { id: @user.id }
    assert_redirected_to root_path
  end

  test 'should destroy user as admin' do
    log_in(@admin)
    delete :destroy, params: { id: @user.id }
    assert_redirected_to users_path
  end
end
