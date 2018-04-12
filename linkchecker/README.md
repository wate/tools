リンクチェッカー
==========================

サイトのリンクチェックを行うことができます。

必要なもの
-------------------

* [Rarukas(remote-arukas)][rarukas]

事前準備
-------------------

Rarukasのセットアップを行っておく必要があります。  
セットアップ方法はRarukasの[リポジトリ][rarukas]を参照してください。

利用方法
-------------------

```
cd <このファイルがあるディレクトリのパス>
rarukas --sync-dir . -c run.sh --type debian --name linkchecker
```

設定方法
-------------------

run.shの「CHECK_URL」の設定内容をリンクチェックを行うサイトのURLに書き換えます。

例：「[https://www.example.net/](https://www.example.net/)」のリンクチェックを行う場合

変更前
```sh
CHECK_URL="https://example.com/"
```

変更後
```sh
CHECK_URL="https://www.example.net/"
```

高度な使い方
-------------------

linkchecker.ini設定内容を変更することにより、  
リンクチェック時のログの出力内容などを変更することができます。

設定方法の詳細は以下のURLを参照してください。
https://wummel.github.io/linkchecker/man5/linkcheckerrc.5.html


注意事項
-------------------

ご自身が管理しているサイトのリンクチェックを行う場合のみ利用してください。

[rarukas]: https://github.com/rarukas/rarukas
[arukas]: https://github.com/rarukas/rarukas
[direnv]: https://github.com/direnv/direnv
