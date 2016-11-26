require 'test_helper'

class DirectoriesControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @base_dir = directories(:base)
    @empty_dir = directories(:empty_dir)
    @has_files = directories(:has_files)

    @user = users(:reg_user)
  end

  test 'should get index unauth redirects' do
    get :index
    assert_redirected_to login_path
  end

  test 'should get index' do
    log_in(@user)
    get :index
    assert_response :success
  end

  test 'load base dir unauth redirects' do
    get :show, params: { id: @base_dir.id }
    assert_redirected_to login_path
  end

  test 'load base dir' do
    log_in(@user)
    get :show, params: { id: @base_dir.id }
    assert_response :success
  end

  test 'load empty dir' do
    log_in(@user)
    get :show, params: { id: @empty_dir.id }
    assert_response :success
  end

  test 'load dir with files' do
    log_in(@user)
    get :show, params: { id: @has_files.id }
    assert_response :success
  end

  test 'should get edit' do
    log_in(@user) # TODO: permissions?
    get :edit, params: { id: @base_dir.id }
    assert_response :success
  end

  test 'post update should update' do
    log_in(@user)
    post :update, params: { id: @base_dir.id, directory: { public: true } }
    assert_redirected_to directory_path(@base_dir)
  end

  test 'get new unauth should redirect' do
    get :new
    assert_redirected_to login_path
  end

  test 'get new regular user' do
    log_in(@user)
    get :new
    assert_response :success
  end

  test 'post create should index' do
    # TODO
  end
end
