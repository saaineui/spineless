require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:admin)
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, session: { email: @admin_user.email, password: 'password' }
    assert logged_in?
    assert_redirected_to @admin_user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@admin_user)
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@admin_user), count: 0
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: '', password: '' }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
