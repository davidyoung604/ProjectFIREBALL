require 'test_helper'

class ExtensionTest < ActiveSupport::TestCase
  test 'extension needs a name' do
    ext = Extension.new
    assert_not ext.valid?
    ext.name = 'blah'
    assert ext.valid?
  end

  test 'extension needs unique name' do
    ext = Extension.new(name: extensions(:txt).name)
    assert_not ext.valid?, 'non-unique name should fail (see fixture)'
    ext.name = 'unique'
    assert ext.valid?
  end

  test 'extension can have files associated with it' do
    ext = Extension.new(name: 'my files')
    f1 = user_files(:txt_1)
    f2 = user_files(:jpg_200)
    f1.extension = ext
    f2.extension = ext
    f1.save
    f2.save

    assert ext.user_files.include? f1
    assert ext.user_files.include? f2
  end
end
