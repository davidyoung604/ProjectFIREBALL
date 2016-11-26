require 'test_helper'

class DirectoriesLayoutTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    @base_dir = directories(:base)
    @empty_dir = directories(:empty_dir)
    @has_files = directories(:has_files)

    user = users(:reg_user)
    post login_path, params: {
      session: { name: user.name, password: user.name.downcase }
    }
  end

  test 'index page' do
    get directories_path
    assert_template 'directories/index'
    assert_select 'a[href=?]', directory_path(@base_dir)
    assert_select 'a[href=?]', directory_path(@empty_dir), 0
    assert_select 'a[href=?]', directory_path(@has_files), 0
  end

  test 'directory is empty' do
    this_dir = @empty_dir
    get directory_path(this_dir)
    assert_template 'directories/show'
    assert_select 'div#main_content' do |e|
      assert_select e, 'a[href=?]', edit_directory_path(this_dir)
    end
  end

  test 'directory has other directories' do
    this_dir = @base_dir
    get directory_path(this_dir)
    assert_template 'directories/show'
    assert_select 'a[href=?]', directory_path(@empty_dir)
    assert_select 'a[href=?]', directory_path(@has_files)
    assert_select 'a[href=?]', edit_directory_path(this_dir)
  end

  test 'directory has files' do
    this_dir = @base_dir
    get directory_path(@base_dir)
    assert_template 'directories/show'
    assert_select 'a[href=?]', directory_path(@empty_dir)
    assert_select 'a[href=?]', directory_path(@has_files)
    assert_select 'a[href=?]', edit_directory_path(this_dir)
  end

  # TODO: expand these tests
end
