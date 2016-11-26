require 'test_helper'

class UserFilesControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @file = user_files(:txt_1)
    @user = users(:reg_user)
  end

  test 'index should redirect unauth' do
    get :index
    assert_redirected_to login_path
  end

  test 'should get index' do
    log_in(@user)
    get :index
    assert_response :success
  end

  test 'show should redirect unauth' do
    get :show, params: { id: @file.id }
    assert_redirected_to login_path
  end

  test 'load a file' do
    log_in(@user)
    get :show, params: { id: @file.id }
    assert_response :success
  end

  test 'show embeddable image' do
    log_in(@user)
    embeddable_image = user_files(:embeddable_image)
    get :show, params: { id: embeddable_image.id }
    assert_response :success
  end

  test 'show embeddable video' do
    log_in(@user)
    embeddable_video = user_files(:embeddable_video)
    get :show, params: { id: embeddable_video.id }
    assert_response :success
  end

  test 'edit should redirect unauth' do
    get :edit, params: { id: @file.id }
    assert_redirected_to login_path
  end

  test 'should allow edit' do
    log_in(@user)
    get :edit, params: { id: @file.id }
    assert_response :success
  end

  test 'should update' do
    log_in(@user)
    file = user_files(:change_me)

    assert_equal 0, file.tags.count
    post :update, params: {
      id: file.id, user_file: { csv_tags: 'foo, bar, baz' }
    }
    assert_equal 3, file.tags.count

    assert_redirected_to user_file_path(file)
  end

  test 'should get untagged redirect unauth' do
    get :untagged
    assert_redirected_to login_path
  end

  test 'should get untagged' do
    log_in(@user)
    get :untagged
    assert_response :success
  end
end
