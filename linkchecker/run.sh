#!/usr/bin/env bash

# リンクチェック対象のURL(ここを変更してね)
CHECK_URL="https://histudy.jp/"

apt-get update
apt-get upgrade -y
apt-get install -y linkchecker python-certifi
WARKING_DIR=$(pwd)
# ログファイル書き出し用にアクセス権を変更
chmod 0777 "${WARKING_DIR}"
# リンクチェックを実行
linkchecker --config="${WARKING_DIR}/linkchecker.ini" --check-extern "${CHECK_URL}"

# dotファイルで出力されている場合は画像に変換
if [ -e "${WARKING_DIR}/linkchecker-out.dot" ]; then
    apt-get install -y graphviz
    /usr/bin/dot -Tpng -o "${WARKING_DIR}/linkchecker-out.png" "${WARKING_DIR}/linkchecker-out.dot"
fi
