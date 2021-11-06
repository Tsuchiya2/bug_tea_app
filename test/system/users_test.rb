require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  def setup
    if User.find_by(email: 'admin@example.com').nil?
      User.create(name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
      User.create(name: 'partner', email: 'partner@example.com', password: 'password', password_confirmation: 'password', admin: false)
    end
  end

  test 'login success with exist admin' do
    visit login_path
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログインする'
    assert_text 'ログインしました。'
    assert_text 'タスク一覧'
  end

  test 'login failed with not exist user' do
    visit login_path
    fill_in 'メールアドレス', with: 'test_user@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログインする'
    assert_text 'メールアドレス'
    assert_no_text 'タスク一覧'
  end

  test 'success create new user' do
    login_admin
    click_on 'ユーザー一覧'
    click_on '新規登録'
    fill_in '名前', with: 'user'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード(確認)', with: 'password'
    click_button '登録する'
    assert_equal User.last.email, 'user@example.com'
  end

  test 'failure create by name blank' do
    login_admin
    click_on 'ユーザー一覧'
    click_on '新規登録'
    fill_in '名前', with: nil
    fill_in 'メールアドレス', with: 'tester@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード(確認)', with: 'password'
    click_button '登録する'
    assert_text '名前を入力してください'
  end

  test 'failure create partner' do
    login_admin
    click_on 'ユーザー一覧'
    click_on '新規登録'
    fill_in '名前', with: 'partner'
    fill_in 'メールアドレス', with: 'partner@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード(確認)', with: 'password'
    click_button '登録する'
    assert_text 'メールアドレスはすでに存在します'
  end

  test 'success show user' do
    login_admin
    click_on 'ユーザー一覧'
    click_on 'partner'
    assert_text User.last.email
  end

  test 'success delete user' do
    login_admin
    click_on 'ユーザー一覧'
    click_on 'partner'
    click_on '削除'
    assert_text 'ユーザー「partner」を削除しました。'
  end


  private

  def login_admin
    visit login_path
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログインする'
  end
end
