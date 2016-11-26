require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login page is sessions/new' do
    get login_path
    assert_template 'sessions/new'
  end

  test 'login with invalid credentials' do
    post login_path, params: {
      session: { name: '', password: '' }
    }
    assert_template 'sessions/new'

    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid credentials' do
    post login_path, params: {
      session: { name: 'Admin', password: 'admin' }
    }
    assert_response :redirect
    follow_redirect!
    assert_template 'stats/index'

    assert flash.empty?, flash.map { |k, v| "#{k}=#{v}" }.join(', ')
  end

  test 'login and logout' do
    post login_path, params: {
      session: { name: 'Admin', password: 'admin' }
    }
    assert_response :redirect
    follow_redirect!
    assert_response :success

    delete logout_path
    assert_response :redirect
    follow_redirect!
    assert_template 'sessions/new'
  end
end
