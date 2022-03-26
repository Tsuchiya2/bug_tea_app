require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  def setup
    # 各テスト項目が実行される前に事前に行われる処理が記載されています。
    User.create(name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
  end

  test 'success create New Task' do
    login_admin   # ← private以下にある'login_admin'メソッドを呼び出しています。以降のテスト項目でも同様です。
    click_on '新規登録'
    fill_in '名称', with: 'New Task'
    fill_in '詳しい説明', with: 'Fill the world with warmth.'
    click_button '登録する'
    assert_equal Task.count, 1
    assert_equal Task.last.description, 'Fill the world with warmth.'
  end

  test 'success create Noting Nmae Task' do
    # admin@example.comでログインして、タスク一覧画面から'新規登録'をクリックして'タスクの新規登録'画面に遷移後、
    # 名称には何も入力しない状態で'登録'をクリックすると、Tasksテーブルに1つレコードが保存されており、
    # そのレコードのnameカラムには'名前なし'が保存されているかをテストします。
    login_admin
    click_on '新規登録'
    fill_in '名称', with: nil
    fill_in '詳しい説明', with: '名前無しタスク'
    click_button '登録する'
    assert_equal Task.count, 1
    assert_equal Task.last.name, '名前なし'
  end

  test 'success update Task' do
    # admin@example.comでログインして、タスクの新規登録画面からタスクを1つ登録後、
    # 遷移先の画面にて'編集'をクリックしてタスクの編集画面にて名称を変更後、
    # '更新する'をクリックして遷移した先の画面にて「Last Task」の文字列が存在するかどうか、
    # また、Tasksテーブルに存在するレコードのnameカラムが'Last Task'になっているかをテストします。
    login_admin
    visit new_task_path
    fill_in '名称', with: 'First Task'
    fill_in '詳しい説明', with: 'First Doing'
    click_button '登録する'
    click_on '編集'
    fill_in '名称', with: 'Last Task'
    click_button '更新する'
    assert_text 'Last Task'
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
