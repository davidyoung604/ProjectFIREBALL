require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'category needs a name' do
    cat = Category.new
    assert_not cat.valid?
    cat.name = 'Audio'
    assert cat.valid?
  end

  test 'category needs unique name' do
    cat = Category.new(name: 'Empty')
    assert_not cat.valid?, 'non-unique name should fail (see fixture)'
    cat.name = 'Unique'
    assert cat.valid?
  end

  test 'category name not empty' do
    cat = Category.new(name: '')
    assert_not cat.valid?, 'name cannot be empty'
  end

  test 'category does not require extensions' do
    cat = categories(:empty)
    assert 0, cat.extensions.length
    assert cat.valid?
  end

  test 'category extensions can be managed via csv' do
    cat = categories(:full)
    ext_names = cat.extensions.map(&:name)
    assert_not arr_includes_all?(ext_names, 'fake1', 'fake2')

    cat.csv_extensions = 'fake1, fake2'
    ext_names = cat.extensions.map(&:name)
    assert arr_includes_all?(ext_names, 'fake1', 'fake2')

    csv_ext = cat.csv_extensions
    ext_names = csv_ext.split(',').map(&:strip)
    assert arr_includes_all?(ext_names, 'fake1', 'fake2'), ext_names
  end

  test 'category can have extensions associated' do
    cat = categories(:full)
    exts = extensions(:jpg, :txt)
    cat.extensions = exts
    assert_not cat.extensions.empty?
    assert cat.valid?
  end

  test 'default categories work' do
    load "#{Rails.root}/db/seeds.rb"
    cat = Category.where(name: 'Video').first

    assert_not cat.extensions.empty?
    ext_str_arr = cat.extensions.map(&:name)

    %w(mp4 mkv mov avi flv).each do |ext|
      assert ext_str_arr.include? ext
    end
  end
end
