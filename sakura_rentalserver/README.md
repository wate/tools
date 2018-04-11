さくらのレンタルサーバーセットアップツール
==========================

さくらのレンタルサーバーの初期設定と、  
WordPressの設置を行うことができます。

### セットアップ内容

このツールはさくらのレンタルサーバーに対して以下の設定を行います。

* SSHの公開鍵の設定
* [usacloud][usacloud]のインストールとセットアップ
    * 設定によりインストールしないようにもできます。
    * レンタルサーバーでは対応しきれない場合などに、  
      [usacloud][usacloud]を使って[さくらのクラウド][sakura_cloud]の機能と連携させることができます。
    * usacloudの利用方法に関してはusacloudの[公式サイト][usacloud]を参照してください。
* PHP環境のセットアップ
* WordPressのインストールとセットアップを行います。  
  また、CRON機能を利用した自動バックアップと自動更新の設定をを行います。

必要なもの
-------------------

このツールを利用するには以下のものがインストールされている必要があります。

* [Ansible][ansible]
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

設定ファイルは以下の2つがあります。

* hosts.yml：さくらのレンタルサーバーの接続情報を定義するファイルです
* config.yml：セットアップ内容定義するファイルです

各設定ファイルの設定内容は以下の通りです。

### hosts.yml

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


config.ymlで設定できるセットアップ内容は以下の通りです。


#### PHPの設定

config.ymlのPHPの設定項目は以下の通りです。

* `php_version`：利用するPHPのバージョンを設定します
    * 設定できる内容は以下の通りです
        * `default`：さくらのレンタルサーバーの標準PHPを利用する場合は、この値を設定します
        * `7.1`：PHPのバージョン7.1を利用する場合は、この値を設定します
        * `5.6`：PHPのバージョン5.6を利用する場合は、この値を設定します
    * その他、設定可能なバージョンに関しては、コントロールパネルよりご確認ください
* `php_use_imageck`：ImageMagickを利用するか否かを設定します
    * 設定できる内容は以下の通りです
        * `true`：ImageMagickを利用する場合は、この値を設定します
        * `false`：ImageMagickを利用しない場合は、この値を設定します
* `php_ini`：php.iniの内容を設定します
    * PHPの設定項目はPHPの[公式サイト][php]を参照してください

**サンプル**

```yml
## 利用するPHPのバージョン(default / 7.1 / 5.6 など)
php_version: default
## Imagickモジュールを利用するか否か(true / false)
php_use_imageck: true
## php.iniの設定
php_ini:
  default_charset: UTF-8
  internal_encoding: ""
  input_encoding: ""
  output_encoding: ""
  post_max_size: 8M
  max_input_vars: 1000
  upload_max_filesize: 2M
  max_file_uploads: 20
  date.timezone: Asia/Tokyo
  mbstring.language: Japanese
  mbstring.detect_order: auto
```

#### WordPressの設定(インストールおよびセットアップ)

* `version`：インストールするWordPressのバージョンを設定します(※通常は変更する必要はありません)
* `locale`：インストールするWordPressの言語を設定します(※通常は変更する必要はありません)
* `url`：サイトのURLを設定します
* `title`：サイト名を設定します
* `admin_user`：管理者のユーザー名を設定します
* `admin_password`：管理者のパスワードを設定します
* `admin_email`：管理者のメールアドレスを設定します
* `db_host`：「[事前準備](#事前準備)」で作成したデータベースの「データベース サーバ」を設定します
* `db_name`：「[事前準備](#事前準備)」で作成したデータベースの「データベース名」を設定します
* `db_user`：「[事前準備](#事前準備)」で作成したデータベースの「データベース ユーザ名」を設定します
* `db_password`：「[事前準備](#事前準備)」作成したデータベースの「接続用パスワード」を設定します
* `db_prefix`：データベースの各テーブルの接頭語を設定します
* `db_charset`：「[事前準備](#事前準備)」作成したデータベースの「データベース 文字コード」を設定します
* `rewrite_structure`：パーマリンク設定の内容を設定します
* `extra_setting`：その他、wp-config.phpに記載するWordPressの設定内容を設定します
* `htaccess`：アクセスコントロールファイル(.htaccess)に記載する内容を設定します
* `plugins`：WordPressのインストール時に同時にインストールするプラグインを設定します
    * 初期設定では以下のURLに記載されている  
      「インストール済みのプラグイン」の内容が設定されています
      * [【クイックインストール】さくらのレンタルサーバ版WordPressの特長](https://help.sakura.ad.jp/hc/ja/articles/206056602--%E3%82%AF%E3%82%A4%E3%83%83%E3%82%AF%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB-%E3%81%95%E3%81%8F%E3%82%89%E3%81%AE%E3%83%AC%E3%83%B3%E3%82%BF%E3%83%AB%E3%82%B5%E3%83%BC%E3%83%90%E7%89%88WordPress%E3%81%AE%E7%89%B9%E9%95%B7)
* `themes`：WordPressのインストール時に同時にインストールするプラグインを設定します
    * 初期設定では未設定の状態になっています
* `import`：WordPressにインポートするデータを設定します
    * 初期設定ではコメントアウトにより無効化されています

**インストールするプラグインの設定方法について**

* `name`：プラグイン名を指定します
    * 必須項目です
    * プラグイン名にはプラグインのスラッグを設定します
* `activate`：プラグインのインストールと同時に有効化する場合は`true`を設定します
    * この項目が省略された場合は無効化した状態でインストールされます
* `version`：インストールするプラグインのバージョンを設定します
    * この項目が省略された場合は最新のバージョンがインストールされます
    * バージョンの指定はプラグインが対応している必要があります

**インストールするテーマの設定方法について**

* `name`：テーマ名を指定します
    * 必須項目です
    * テーマ名にはテーマのスラッグを設定します
* `active`：テーマのインストールと同時に有効化する場合は`true`を設定します
    * この項目が省略された場合は無効化した状態でインストールされます
* `version`：インストールするプラグインのバージョンを設定します
    * この項目が省略された場合は最新のバージョンがインストールされます
    * バージョンの指定はプラグインが対応している必要があります

**インポートデータの設定方法について**

* `file`：インポートするデータのURLまたはファイルのパスを設定します
    * 必須項目です
* `authors`：インポートするデータにユーザー情報の扱いを設定します。
    * 設定できる内容は以下の通りです
        * `create`：インポート時にユーザーを追加します
        * `skip`：存在しないユーザーのデータをスキップします。
        * `ユーザーマッピングファイル名`：インポートするデータのユーザーのを行う場合は変換設定が記載されたファイルのパスを指定します
    * 詳細は[wp-cli][]の`wp import`コマンドの[ページ](https://developer.wordpress.org/cli/commands/import/)を参照してください

**サンプル**

```yml
wordpress:
  ## ダウンロードするWordPressの設定
  version: latest
  locale: ja
  ## インストールの設定
  url: "{{ ansible_user }}.sakura.ne.jp"
  title: サンプルサイト
  admin_user: supervisor
  admin_password: str0ngp@55w0rd
  admin_email: info@example.com
  ## データベースの設定
  db_host: mysqlXXX.db.sakura.ne.jp
  db_name: "{{ ansible_user }}_wordpress"
  db_user: "{{ ansible_user }}"
  db_password: vErY_VeRy_Str0ng_P@55w0rd
  db_prefix: wp_
  db_charset: utf8mb4
  ## パーマリンクの設定
  rewrite_structure: /%category%/%postname%/
  extra_setting: |
    define('WP_DEBUG', false);
    define('WP_DEBUG_DISPLAY', false);
    define('WP_POST_REVISIONS', false);
    define('DISALLOW_FILE_EDIT', true);
  ## アクセスコントロールファイルの設定
  htaccess: |
    <IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
    </IfModule>
  ## インストールするプラグインの設定
  plugins:
    # Autoptimizeプラグイン
    - name: autoptimize
      activate: true
    # Disable Google Fontsプラグイン
    - name: disable-google-fonts
      activate: true
    # ImageMagick Engineプラグイン
    - name: imagemagick-engine
      activate: true
    # Remove query strings from resourcesプラグイン
    - name: remove-query-strings-from-static-resources
      activate: true
    # Protect Uploadsプラグイン
    - name: protect-uploads
      activate: true
    # All In One WP Security & Firewallプラグイン
    - name: all-in-one-wp-security-and-firewall
      activate: true
    # TypeSquare Webfonts SAKURA for SAKURA Rental Serverプラグイン
    - name: ts-webfonts-for-sakura
      activate: true
    # さくらのレンタルサーバ 簡単SSL化プラグイン
    - name: sakura-rs-wp-ssl
    # - name: some-plugin-name
    #   activate: true (optional)
    #   version: "1.2.3" (optional)
  ## インストールするテーマの設定
  themes: []
    # - name: some-theme-name
    #   active: true (optional)
    #   version: 1.2.3 (optional)
  ## インポートするデータの設定
  # import:
  #   file: https://raw.githubusercontent.com/jawordpressorg/theme-test-data-ja/master/wordpress-theme-test-date-ja.xml
  #   authors: create
```

#### WordPressの自動バックアップ設定

* `enabled`：自動バックアップの設定を行うか否かを設定します(`true` / `false`)
* `hour`：自動バックアップを実行する時刻(時)を設定します
* `minute`：自動バックアップを実行する時刻(分)を設定します

**サンプル**

```yml
wordpress_backup_job:
  # 自動バックアップを有効化する
  enabled: true
  # 自動バックアップの実行時間(時)を0〜6の間でランダムに設定
  # ※「enabled」に「true」が設定されている場合のみ有効
  hour: "{{ 6 | random(seed=inventory_hostname) }}"
  # 自動バックアップの実行時間(分)を0〜59の間でランダムに設定
  # ※「enabled」に「true」が設定されている場合のみ有効
  minute: "{{ 59 | random(seed=inventory_hostname) }}"
```

#### WordPressの自動更新設定

* `enabled`：自動更新の設定を行うか否を設定します(`true` / `false`)
* `hour`：自動更新を実行する時刻(時)を設定します
* `minute`：自動更新を実行する時刻(分)を設定します

**サンプル**

```yml
wordpress_update_job:
  # 自動更新を無効化する(自動更新を行わない)
  enabled: false
  # 自動更新の実行時間(時)を1〜7の間でランダムに設定
  # ※「enabled」に「true」が設定されている場合のみ有効
  hour: "{{ 7 | random(seed=inventory_hostname, start=1) }}"
  # 自動更新の実行時間(分)を0〜59の間でランダムに設定
  # ※「enabled」に「true」が設定されている場合のみ有効
  minute: "{{ 59 | random(seed=inventory_hostname) }}"
```

#### usacloudの設定

* `install`：[usacloud][usacloud]をインストールするか否かを設定します(`true` / `false`)
* `version`：インストールする[usacloud][usacloud]のバージョンを設定します
* `token`：[さくらのクラウド][sakura_cloud]のアクセストークンを設定します
* `secret`：[さくらのクラウド][sakura_cloud]のアクセストークンシークレットを設定します
* `zone`：[さくらのクラウド][sakura_cloud]のデフォルトのゾーンを設定します
* `output_type`：デフォルトの出力形式を設定します
* `ojs_access_key_id`：[オブジェクトストレージの][object-storage]のアクセスキーIDを設定します
* `ojs_secret_access_key`：[オブジェクトストレージの][object-storage]のシークレットアクセスキーを設定します

**サンプル**

※以下のサンプルは、Ansibleを実行するPCに設定されているusacloud用の環境変数と同じものを設定するように記載されています

```yml
usacloud:
  # usacloudをインストールするか否か(true / false)
  install: true
  # usacloudのバージョン
  version: "0.11.0"
  # さくらのクラウド APIキー(アクセストークン)
  token: "{{ lookup('env', 'SAKURACLOUD_ACCESS_TOKEN') }}"
  # さくらのクラウド APIキー(アクセストークンシークレット)
  secret: "{{ lookup('env', 'SAKURACLOUD_ACCESS_TOKEN_SECRET') }}"
  # ゾーン: is1a / is1b / tk1a / tk1v
  zone: "{{ lookup('env', 'SAKURACLOUD_ZONE') }}"
  # デフォルトの出力形式: table / json / csv / tsv
  output_type: table
  # オブジェクトストレージ アクセスキー(アクセスキーID)
  ojs_access_key_id: "{{ lookup('env', 'SACLOUD_OJS_ACCESS_KEY_ID') }}"
  # オブジェクトストレージ アクセスキー(シークレットアクセスキー)
  ojs_secret_access_key: "{{ lookup('env', 'SACLOUD_OJS_SECRET_ACCESS_KEY') }}"
```

#### SSHの公開鍵の設定

* `key`：登録する公開鍵の内容を設定します
    * 必須項目です
* `state`：登録済みの公開鍵を削除する場合は`false`を設定します

**サンプル**

※以下のサンプルは、Ansibleを実行するPCに保存されている公開鍵のパスを指定するように記載されています

```yml
authorized_keys:
  - key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
  - key: "{{ lookup('file', '~/.ssh/removed.pub') }}"
    state: false
```

[ansible]: https://www.ansible.com/
[usacloud]: https://sacloud.github.io/usacloud/
[sakura_cloud]: https://cloud.sakura.ad.jp/
[php]: http://php.net/manual/ja/index.php
[wp-cli]: http://wp-cli.org/
[object-storage]: https://cloud.sakura.ad.jp/specification/object-storage/
[baskup_and_staging]: https://www.sakura.ne.jp/function/backup_staging.html
