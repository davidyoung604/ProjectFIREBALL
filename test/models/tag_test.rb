require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @f1, @f2 = user_files(:txt_1, :jpg_200)
  end

  test 'tag needs a name' do
    tag = Tag.new
    assert_not tag.valid?
    tag.name = 'blah'
    assert tag.valid?
  end

  test 'tag needs unique name' do
    tag = Tag.new(name: 'one')
    assert_not tag.valid?, 'non-unique name should fail (see fixture)'
  end

  test 'tag name not empty' do
    tag = Tag.new(name: '')
    assert_not tag.valid?, 'name cannot be empty'
    tag.name = 'a'
    assert tag.valid?
  end

  test 'tag can have files associated with it' do
    tag = Tag.new(name: 'my files')
    @f1.tags << tag
    @f2.tags << tag

    assert tag.user_files.include? @f1
    assert tag.user_files.include? @f2
  end
end
