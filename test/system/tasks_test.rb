require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  def setup
    if User.find_by(email: 'admin@example.com').nil?
      User.create(name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
    end
  end

  test 'success create New Task' do
    login_admin
    click_on '新規登録'
    fill_in '名称', with: 'New Task'
    fill_in '詳しい説明', with: 'Fill the world with warmth.'
    click_button '登録する'
    assert_equal Task.last.description, 'Fill the world with warmth.'
    assert_equal Task.count, 1
  end

  test 'success create Noting Nmae Task' do
    login_admin
    click_on '新規登録'
    fill_in '名称', with: nil
    fill_in '詳しい説明', with: '名前無しタスク'
    click_button '登録する'
    assert_equal Task.last.name, '名前なし'
    assert_equal Task.count, 1
  end

  test 'success update Before Task' do
    login_admin
    click_on '新規登録'
    fill_in '名称', with: 'Default Task'
    fill_in '詳しい説明', with: 'Default Task'
    click_button '登録する'

    visit new_task_path
    fill_in '名称', with: 'First Task'
    fill_in '詳しい説明', with: 'First Doing'
    click_button '登録する'
    click_on '編集'
    fill_in '名称', with: 'Last Task'
    click_button '更新する'
    assert_equal Task.last.name, 'Last Task'
  end

  private

  def login_admin
    visit login_path
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログインする'
  end
end
