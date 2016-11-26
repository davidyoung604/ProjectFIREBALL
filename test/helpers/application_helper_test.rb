require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'tag suggestion does not show duplicates' do
    path = '/music/artists/babymetal/babymetal song'
    s_tags = get_suggested_tags(path)
    assert_equal %w(artists babymetal music song), s_tags.sort
  end

  test 'tag suggestion ignores words' do
    path = '/home/david/music/artists/babymetal'
    s_tags = get_suggested_tags(path)
    assert_equal %w(artists babymetal david music), s_tags.sort
  end

  test 'tag suggestion ignores solo symbols' do
    path = '/home/david/music/artists/babymetal/01 - babymetal - song! !'
    s_tags = get_suggested_tags(path)
    assert_equal %w(01 artists babymetal david music song!), s_tags.sort
  end
end
