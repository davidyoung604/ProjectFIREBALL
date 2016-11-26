require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'should get new' do
    assert_routing login_path, controller: 'sessions', action: 'new'
    get :new
    assert_response :success
  end
end
