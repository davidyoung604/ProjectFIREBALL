require 'test_helper'

class UserCreationTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    @admin = users(:admin)
    post login_path, params: {
      session: { name: @admin.name, password: @admin.name.downcase }
    }
  end

  test 'invalid info rejected' do
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: '',
          admin: false,
          password: 'foobar',
          password_confirmation: 'barfoo'
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div#form_errors'
  end

  test 'valid info accepted' do
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'dummy-user',
          admin: false,
          password: 'foobar',
          password_confirmation: 'foobar'
        }
      }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
  end
end
