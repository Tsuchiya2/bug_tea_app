# 概要

後述のテスト実行コマンドがエラーにならないように修正をお願いします。

## 環境構築

```Bash
・ git clone git@github.com:Tsuchiya2/bug_tea_app.git
・ cd bug_tea_app
・ git remote rm origin
・ git checkout -b fix_○○_xxxx
・ rbenv local 2.5.1
・ bundle install
・ bin/rails db:migrate
・ bin/rails db:seed
・ bin/rails s
```

＊SSHではなく、HTTPSの場合は `git clone https://github.com/Tsuchiya2/bug_tea_app.git` になります。

〇〇のところには`期`を、xxxxのところには`名前`を入力してください。

***

## ログイン

【admin権限を持つユーザーでログイン】

- メールアドレス：admin@example.com
- パスワード：password
- admin権限：true

【一般ユーザーでログイン】

- メールアドレス：user@example.com
- パスワード：password
- admin権限：false

***

## テスト実行

```Bash
 rails test:system
```

※ ローカルでMiniTestのテストコードが成功する様な修正が確認できれば完了となります。修正したコードのcommitやpushは不要です。

***

## ヒント

`test/system/users_test.rb`, `test/system/tasks_test.rb`の中身を見て、どんなことを機械にさせようとしているのかを読み取り、実際にブラウザで同じ操作を行ってみましょう。
