require 'test_helper'

class DirectoryTest < ActiveSupport::TestCase
  test 'dir needs name' do
    dir = Directory.new
    assert_not dir.valid?, 'dir needs a name'
    dir.name = '/base_dir'
    assert dir.valid?
  end

  test 'dir needs unique name' do
    dir = Directory.new(name: '/base')
    assert_not dir.valid?, 'non-unique name should fail (see fixture)'
  end

  test 'dir name not empty' do
    dir = Directory.new(name: '')
    assert_not dir.valid?, 'name cannot be empty'
    dir.name = '/'
    assert dir.valid?
  end

  test 'dir can be empty' do
    dir = directories(:empty_dir)
    assert_equal 0, dir.user_files.length
  end

  test 'dir can have files associated' do
    dir = directories(:has_files)
    assert_not dir.user_files.empty?
  end

  # because the dir itself doesn't have tags, it pulls from the first file
  test 'dir uses tags of first child file as defaults' do
    dir = directories(:has_files)
    # need the first child file of dir (that's where tags are pulled from)
    file = dir.user_files.first
    assert_equal file.csv_tags, dir.csv_tags

    file.csv_tags = 'fake1, fake2'
    # reload is only called for test purposes
    dir.reload
    assert_equal file.csv_tags, dir.csv_tags
  end

  test 'dir csv tags are applied to all child files' do
    dir = directories(:has_files)
    # paranoia check that we have at least two files
    assert dir.user_files.count > 1
    dir.user_files.each { |file| assert_equal 0, file.tags.count }

    dir.csv_tags = 'fake1, fake2'
    dir.user_files.each do |file|
      assert_equal 2, file.tags.count
      assert arr_includes_all?(file.tags.map(&:name), 'fake1', 'fake2')
    end
  end

  test 'dir csv tags no default cascade' do
    dir = directories(:base)
    dir_w_files = directories(:has_files)
    # paranoia check that the hierarchy is right
    assert dir_w_files.parent == dir
    # paranoia check that we have at least two files
    assert dir_w_files.user_files.count > 1
    dir_w_files.user_files.each { |file| assert_equal 0, file.tags.count }

    dir.csv_tags = 'fake1, fake2'
    dir_w_files.user_files.each do |file|
      assert_equal 0, file.tags.count
    end
  end

  test 'dir csv tags can cascade' do
    dir = directories(:base)
    dir_w_files = directories(:has_files)
    # paranoia check that the hierarchy is right
    assert dir_w_files.parent == dir
    # paranoia check that we have at least two files
    assert dir_w_files.user_files.count > 1
    dir_w_files.user_files.each { |file| assert_equal 0, file.tags.count }

    dir.cascade = true
    dir.csv_tags = 'fake1, fake2'
    dir_w_files.user_files.each do |file|
      assert_equal 2, file.tags.count
      assert arr_includes_all?(file.tags.map(&:name), 'fake1', 'fake2')
    end
  end

  test 'dir public setting applied to all child files' do
    dir = directories(:has_files)
    # paranoia check that we have at least two files
    assert dir.user_files.count > 1
    dir.user_files.each { |file| assert_not file.public }

    dir.public = true
    dir.user_files.each { |file| assert file.public }
  end
end
