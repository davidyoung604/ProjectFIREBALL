require 'test_helper'

class UserFileTest < ActiveSupport::TestCase
  def setup
    @dir_id = directories(:has_files).id
    @file = user_files(:txt_1)
    @tags = tags(:one, :two, :three)
    @admin = users(:admin)
  end

  test 'file needs name' do
    file = UserFile.new(directory_id: @dir_id, user_id: @admin.id)
    assert_not file.valid?, 'file needs a name'
    file.name = 'file.txt'
    assert file.valid?
  end

  test 'file name not empty' do
    file = UserFile.new(name: '', directory_id: @dir_id, user_id: @admin.id)
    assert_not file.valid?, 'name cannot be empty'
    file.name = 'a'
    assert file.valid?
  end

  test 'directory needed' do
    file = UserFile.new(name: 'file.txt', user_id: @admin.id)
    assert_not file.valid?, 'missing directory id'
    file.directory_id = @dir_id
    assert file.valid?
  end

  test 'user needed' do
    file = UserFile.new(name: 'unique.txt', directory_id: @dir_id)
    assert_not file.valid?
    file.user = @admin
    assert file.valid?
  end

  test 'extension supported, but not needed' do
    file = UserFile.new(name: 'unique.txt', directory_id: @dir_id,
                        user_id: @admin.id)
    ext = extensions(:txt)
    assert file.valid?
    file.extension = ext
    assert file.valid?
  end

  test 'tags can be managed via CSV' do
    assert_equal 0, @file.tags.length
    @file.csv_tags = [@tags[0], @tags[1]].map(&:name).join(', ')
    assert_equal 2, @file.tags.length
    assert_equal "#{@tags[0].name}, #{@tags[1].name}", @file.csv_tags
    @file.tags << @tags[2]
    assert_equal 3, @file.tags.length
    assert_equal @tags.map(&:name).join(', '), @file.csv_tags
  end
end
