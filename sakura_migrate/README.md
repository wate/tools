さくらのレンタルサーバーデータ移行ツール
==========================

運営中のサイトの内容を新しいさくらのレンタルサーバーのアカウントに移設することができます。  
※新たに取得したアカウントに、現在運営中のWordPressサイトを移設することを想定しています。

### 移設できる内容

* Webサイトのデータ(`~/www`以下の全ファイル)
* WordPressのデータベースの内容
* 環境設定ファイル
    * .cshrc
    * .login
    * .login_conf
    * .profile
    * .shrc
    * .php.version
    * .my.version
    * .cpanelrc
* メール情報
    * 各メールボックスおよび受信箱の内容
    * 迷惑メール学習データ

必要なもの
-------------------

このツールを利用するには以下のものがインストールされている必要があります。

* [Ansible](https://www.ansible.com/)
    * ※バージョン 2.4以上

利用方法
-------------------

```
cd <このファイルがあるディレクトリのパス>
ansible-playbook migrate.yml
```

事前準備
-------------------

このツールを利用するための事前準備は以下の通りです。

* 移転先アカウントのコントロールパネルにログインし、  
  WordPress用のデータベースを作成しておく必要があります。

設定方法
-------------------

設定ファイルの設定内容は以下の通りです。

### config.yml

```yml
all:
  vars:
    ansible_python_interpreter: /usr/local/bin/python
    # SSHの秘密鍵のパスを設定します
    ssh_private_key: ~/.ssh/id_rsa
    # SSHの公開鍵のパスを設定します
    ssh_public_key: ~/.ssh/id_rsa.pub
sync_hosts:
  hosts:
    from:
      # 移転元アカウントの接続情報を設定します
      ansible_host: wwwXXXX.sakura.ne.jp
      ansible_user: from-acount
      ansible_ssh_pass: from_P@55s0rd
      ansible_connection: paramiko
    to:
      # 移転先アカウントの接続情報を設定します
      ansible_host: wwwYYYY.sakura.ne.jp
      ansible_user: to-acount
      ansible_ssh_pass: to_P@55s0rd
      ansible_connection: paramiko
      # 移行後のWordPressの設定情報を設定します
      wordpress:
        # 移行先のデータベース サーバ
        db_host: mysqlXXX.db.sakura.ne.jp
        # 移行先のデータベース名
        db_name: "{{ hostvars.to.ansible_user }}_wordpress"
        # 移行先のデータベース ユーザー名
        db_user: "{{ hostvars.to.ansible_user }}"
        # 移行先のデータベース 接続用パスワード
        db_password: vErY_VeRy_Str0ng_P@55w0rd
        # 移行先のデータベース 文字コード
        db_charset: utf8mb4
        ## 一般設定の「WordPress アドレス (URL)」の設定値
        ## (※移設に伴いURLが変更になる場合のみ以下のコメントアウトを解除し、移行後のURLを設定します)
        # siteurl: "http://to.sakura.ne.jp/"
        ## 一般設定の「サイトアドレス (URL)」の設定値
        ## (※移設に伴いURLが変更になる場合のみ以下のコメントアウトを解除し、移行後のURLを設定します)
        # home: "http://to.sakura.ne.jp/"
        ## 移設に伴いURLが変更になる場合は、WordPressのデータの書き換えを内容を設定します
        replaces: []
          # - search: "http://from.sakura.ne.jp/"
          #   replace: "http://to.sakura.ne.jp/"
```
