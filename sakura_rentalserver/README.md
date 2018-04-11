さくらのレンタルサーバーセットアップツール
==========================

さくらのレンタルサーバーの初期設定と、  
WordPressの設置を行うことができます。

### セットアップ内容

このツールはさくらのレンタルサーバーに対して以下の設定を行います。

* SSHの公開鍵の設定
* usacloudのインストールとセットアップ
    * 設定によりインストールしないようにもできます。
    * usacloudを利用することでレンタルサーバーでは対応しきれない場合に、  
    [さくらのクラウド](https://cloud.sakura.ad.jp/)の機能を使って連携させることができます。
    * usacloudの利用方法に関しては[公式サイト](https://sacloud.github.io/usacloud/)を参照してください。
* PHP環境のセットアップ
* WordPressのインストールとセットアップ

必要なもの
-------------------

このツールを利用するには以下のものがインストールされている必要があります。

* [Ansible](https://www.ansible.com/)
    * ※バージョン 2.4以上

利用方法
-------------------

```
cd <このファイルがあるディレクトリのパス>
ansible-playbook setup.yml
```

事前準備
-------------------

このツールを利用するための事前準備は以下の通りです

* コントロールパネルにログインし、  
  WordPress用のデータベースを作成しておく必要があります。

設定ファイルおよび設定方法
-------------------

### hosts.yml

さくらのレンタルサーバーに接続するための接続情報を定義するファイルです。  
設定項目の内容は以下の通りです。

#### example.sakura.ne.jp

初期ドメインの内容を設定します。  
hosts.ymlの「example.sakura.ne.jp」の部分を、  
さくらのレンタルサーバーの「初期ドメイン」の内容に書き換えます。

##### 例：初期ドメインが「hoge.sakura.ne.jp」の場合

変更前
```yml
sakura_rental_servers:
  hosts:
    "example.sakura.ne.jp":
      ansible_host: wwwXXXXXX.sakura.ne.jp
      ansible_user: example
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

変更後
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: wwwXXXXXX.sakura.ne.jp
      ansible_user: example
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

#### ansible_host

さくらのレンタルサーバーの接続先ホスト名を設定します。  
設定する内容は以下の手順で確認することができます。

1. コントロールパネルにログインします。
2. 左メニューの「サーバ情報の表示」のリンクをクリックします。
3. 「サーバに関する情報」のリンクをクリックします。
4. 「\* サーバに関する情報\* 」の「ホスト名」の内容を設定します。

##### 例：ホスト名が「www1234.sakura.ne.jp」の場合

変更前
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: wwwXXXXXX.sakura.ne.jp
      ansible_user: example
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

変更後
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: www1234.sakura.ne.jp
      ansible_user: example
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

#### ansible_user

「仮登録完了のお知らせ」メールに記載されている  
「FTPアカウント」の内容を設定します。

##### 例：「FTPアカウント」が「hoge」の場合

変更前
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: www1234.sakura.ne.jp
      ansible_user: example
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

変更後
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: www1234.sakura.ne.jp
      ansible_user: hoge
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

#### ansible_ssh_pass

「仮登録完了のお知らせ」メールに記載されている  
「サーバパスワード」の内容を設定します。

※コントロールパネルより「サーバパスワード」を変更されている場合は、  
変更したの「サーバパスワード」の内容を設定してください。

##### 例：「サーバパスワード」が「str0ngp@55w0rd」の場合

変更前
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: www1234.sakura.ne.jp
      ansible_user: hoge
      ansible_ssh_pass: ex@mple_user_p@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

変更後
```yml
sakura_rental_servers:
  hosts:
    "hoge.sakura.ne.jp":
      ansible_host: www1234.sakura.ne.jp
      ansible_user: hoge
      ansible_ssh_pass: str0ngp@55w0rd
      ansible_connection: paramiko
  vars:
    ansible_python_interpreter: /usr/local/bin/python
```

### config.yml

さくらのレンタルサーバーのセットアップ内容を定義する設定ファイルです。

**後で書く**
