require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @user = users(:reg_user)
    @admin = users(:admin)
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

  test 'should get show unauth redirects' do
    get :show, params: { id: categories(:full).id }
    assert_redirected_to login_path
  end

  test 'should get show' do
    log_in(@user)
    get :show, params: { id: categories(:full).id }
    assert_response :success
  end

  test 'should get destroy unauth redirects' do
    get :destroy, params: { id: categories(:delete_me).id }
    assert_redirected_to login_path
  end

  test 'should get destroy regular user redirects' do
    log_in(@user)
    get :destroy, params: { id: categories(:delete_me).id }
    assert_redirected_to root_path
  end

  test 'should get destroy' do
    log_in(@admin)
    get :destroy, params: { id: categories(:delete_me).id }
    assert_redirected_to categories_path
  end

  test 'should get destroy unsorted fails' do
    log_in(@admin)
    unsorted = categories(:unsorted)
    get :destroy, params: { id: unsorted.id }
    assert_redirected_to unsorted
  end

  test 'should get new redirects regular user' do
    log_in(@user)
    get :new
    assert_redirected_to root_path
  end

  test 'new should succeed admin' do
    log_in(@admin)
    get :new
    assert_response :success
  end

  test 'create should redirect regular user' do
    log_in(@user)
    assert_equal Category.where(name: 'Documents').count, 0
    post :create, params: {
      category: { name: 'Documents', csv_tags: 'txt, md, doc' }
    }
    assert_redirected_to root_path
    assert_equal Category.where(name: 'Documents').count, 0
  end

  test 'create should succeed admin' do
    log_in(@admin)
    assert_equal Category.where(name: 'Documents').count, 0
    post :create, params: {
      category: { name: 'Documents', csv_tags: 'txt, md, doc' }
    }
    assert_redirected_to categories_path
    assert_equal Category.where(name: 'Documents').count, 1
  end

  test 'create invalid should fail' do
    log_in(@admin)
    assert_equal Category.where(name: 'Documents').count, 0
    post :create, params: {
      category: { name: '', csv_tags: 'txt, md, doc' }
    }
    assert_response :success
    assert_equal Category.where(name: 'Documents').count, 0
  end

  test 'get edit regular user redirects' do
    log_in(@user)
    get :edit, params: { id: categories(:full).id }
    assert_redirected_to root_path
  end

  test 'get edit admin' do
    log_in(@admin)
    get :edit, params: { id: categories(:full).id }
    assert_response :success
  end

  test 'update invalid should fail' do
    log_in(@admin)
    cat = categories(:change_me)
    old_name = cat.name
    new_name = 'New Category'

    assert_equal Category.where(name: old_name).count, 1
    assert_equal Category.where(name: new_name).count, 0

    post :update, params: { id: cat.id, category: { name: '' } }

    assert_equal Category.where(name: old_name).count, 1
    assert_equal Category.where(name: new_name).count, 0

    assert_response :success
  end

  test 'update should succeed' do
    log_in(@admin)
    cat = categories(:change_me)
    old_name = cat.name
    new_name = 'New Category'

    assert_equal Category.where(name: old_name).count, 1
    assert_equal Category.where(name: new_name).count, 0

    post :update, params: { id: cat.id, category: { name: new_name } }

    assert_equal Category.where(name: old_name).count, 0
    assert_equal Category.where(name: new_name).count, 1

    assert_redirected_to category_path(cat)
  end

  test 'should get unsorted' do
    log_in(@user)
    get :show, params: { id: categories(:unsorted).id }
    assert_response :success
  end
end
