require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @f1, @f2 = user_files(:txt_1, :jpg_200)
  end

  test 'user needs a name' do
    user = User.new(password: 'foobar', password_confirmation: 'foobar')
    assert_not user.valid?
    user.name = 'blah'
    assert user.valid?
  end

  test 'user needs unique name' do
    user = User.new(name: users(:reg_user).name)
    assert_not user.valid?, 'non-unique name should fail (see fixture)'
  end

  test 'user name not empty' do
    user = User.new(name: '', password: 'foobar',
                    password_confirmation: 'foobar')
    assert_not user.valid?, 'name cannot be empty'
    user.name = 'a'
    assert user.valid?
  end

  test 'password cannot be empty' do
    user = User.new(name: 'my user', password: '', password_confirmation: '')
    assert_not user.valid?
  end

  test 'password and confirmation must be equal' do
    user = User.new(name: 'my user', password: 'a', password_confirmation: 'b')
    assert_not user.valid?
  end

  test 'user does not require files' do
    user = users(:reg_no_files)
    user.password = user.password_confirmation = 'foobar'
    assert 0, user.user_files.length
    assert user.valid?
  end

  test 'user can have files associated with it' do
    user = User.new(name: 'my files', password: 'foobar',
                    password_confirmation: 'foobar')
    assert user.user_files.empty?

    @f1.user = user
    @f2.user = user
    @f1.save
    @f2.save

    assert user.user_files.include? @f1
    assert user.user_files.include? @f2
  end
end
