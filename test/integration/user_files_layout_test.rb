require 'test_helper'

class UserFilesLayoutTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    user = users(:reg_user)
    post login_path, params: {
      session: { name: user.name, password: user.name.downcase }
    }
  end

  test 'index page' do
    get user_files_path
    assert_template 'user_files/index'
  end

  test 'file page' do
    get user_file_path(user_files(:txt_1))
    assert_template 'user_files/show'
  end

  # TODO: expand these tests
end
