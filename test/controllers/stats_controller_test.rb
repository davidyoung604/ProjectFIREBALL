require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @user = users(:reg_user)
  end

  test 'get index unauth should redirect' do
    get :index
    assert_redirected_to login_path
  end

  test 'get index regular user' do
    log_in(@user)
    get :index
    assert_response :success
  end

  test 'get show unauth should redirect' do
    get :show, params: { id: 1 }
    assert_redirected_to login_path
  end

  test 'get show regular user' do
    log_in(@user)
    get :show, params: { id: 1 }
    assert_response :success
  end

  test 'get size by category' do
    log_in(@user)
    get :show, params: { id: 'size_by_category' }
    assert_response :success
  end

  test 'get n largest files' do
    log_in(@user)
    get :show, params: { id: '10_largest_files' }
    assert_response :success
  end

  test 'get data usage n days' do
    log_in(@user)
    get :show, params: { id: 'data_usage_10_days' }
    assert_response :success
  end

  test 'get top n tags' do
    log_in(@user)
    file = user_files(:jpg_200)
    file.tags = [tags(:one)]
    get :show, params: { id: 'top_10_tags' }
    assert_response :success
  end
end
