require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @user = users(:reg_user)
    @admin = users(:admin)
  end

  test 'should get index redirect unauth' do
    get :index
    assert_redirected_to login_path
  end

  test 'should get index' do
    log_in(@user)
    get :index
    assert_response :success
  end

  test 'should get show redirect unauth' do
    get :show, params: { id: tags(:one).id }
    assert_redirected_to login_path
  end

  test 'should get show' do
    log_in(@user)
    get :show, params: { id: tags(:one).id }
    assert_response :success
  end

  test 'should get destroy redirect unauth' do
    get :destroy, params: { id: tags(:one).id }
    assert_redirected_to login_path
  end

  test 'should get destroy redirect regular user' do
    log_in(@user)
    get :destroy, params: { id: tags(:one).id }
    assert_redirected_to root_path
  end

  test 'should get destroy as admin' do
    log_in(@admin)
    get :destroy, params: { id: tags(:one).id }
    assert_redirected_to tags_path
  end
end
