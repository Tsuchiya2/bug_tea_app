require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  def setup
    # 各テスト項目が実行される前に事前に行われる処理が記載されています。
    User.create(name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
    User.create(name: 'partner', email: 'partner@example.com', password: 'password', password_confirmation: 'password', admin: false)
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
    login_admin   # ← private以下にある'login_admin'メソッドを呼び出しています。以降のテスト項目でも同様です。
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
    # admin@example.comでログインして、新規ユーザーを「名前をnil (空欄)」で登録しようとすると、
    # 検証が機能して新規ユーザー登録が失敗し、画面に「名前を入力してください」と表示されるかをテストします。
    login_admin
    click_on 'ユーザー一覧'
    click_on '新規登録'
    fill_in '名前', with: ''
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

  test 'success delete user by show' do
    # admin@example.comでログインして、ユーザー一覧から'partner'(名前)をクリックしてユーザーの詳細画面に遷移後、
    # '削除'をクリックすると、画面に「ユーザー「partner」を削除しました。」と表示されるかをテストします。
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
