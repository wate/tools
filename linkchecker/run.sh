#!/usr/bin/env bash

# リンクチェック対象のURL(ここを変更してね)
CHECK_URL="http://example.com/"

apt-get update
apt-get upgrade -y
apt-get install -y linkchecker python-certifi
WARKING_DIR=$(pwd)
# ログファイル書き出し用にアクセス権を変更
chmod 0777 "${WARKING_DIR}"
chmod 0666 "${WARKING_DIR}/linkchecker-out.*"
# リンクチェックを実行
linkchecker --config="${WARKING_DIR}/linkchecker.ini" --check-extern "${CHECK_URL}"
