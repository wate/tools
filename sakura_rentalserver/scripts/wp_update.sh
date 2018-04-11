#!/usr/bin/env bash

# 本体の更新をマイナーバージョンアップのみに限定するか否か(y/n)
CORE_UPDATE_ONLY_MINOR='n'

# 有効化されているプラグインのみを更新対象にするか否か(y/n)
PLUGIN_UPDATE_ONLY_ACTIVED='n'

# プラグインの更新をパッチバージョンアップのみ行うようにするか否か(y/n)
PLUGIN_UPDATE_ONLY_PATCH='n'
# プラグインの更新をマイナーバージョンアップのみ行うようにするか否か(y/n)
# ※「PLUGIN_UPDATE_ONLY_PATCH」に「y」が設定されている場合は、
# 「PLUGIN_UPDATE_ONLY_PATCH」の設定が優先されます
PLUGIN_UPDATE_ONLY_MINOR='n'

# 有効化されているテーマのみを更新対象にするか否か(y/n)
THEME_UPDATE_ONLY_ACTIVED='n'

cd ~/www || exit 1;

if ! ~/bin/wp core is-installed &>/dev/null ; then
    echo "WordPress not installed"
    exit 0;
fi

CORE_UPDATE_PARAM=''
if [ "${CORE_UPDATE_ONLY_MINOR}" == 'y' ]; then
    CORE_UPDATE_PARAM='--minor'
fi
CORE_UPDATE_CHECK_RESULT=$(~/bin/wp core check-update ${CORE_UPDATE_PARAM})
echo '# -----------------------'
echo '# Core Update Status'
echo '# -----------------------'
echo "wp core check-update ${CORE_UPDATE_PARAM}"
echo ${CORE_UPDATE_CHECK_RESULT}

if [[ -n $(echo ${CORE_UPDATE_CHECK_RESULT} | tail -n +2) ]]; then
    ~/bin/wp core update ${CORE_UPDATE_PARAM}
fi

PLUGIN_UPDATE_CHECK_PARAM=''
if [ "${PLUGIN_UPDATE_ONLY_ACTIVED}" == 'y' ]; then
    PLUGIN_UPDATE_CHECK_PARAM='--status=active'
fi
echo '# -----------------------'
echo '# Plugin Update Status'
echo '# -----------------------'
echo "wp plugin list --update=available"

~/bin/wp plugin list --update=available

PLUGIN_UPDATE_OPTION=''
if [ "${PLUGIN_UPDATE_ONLY_PATCH}" == 'y' ]; then
    PLUGIN_UPDATE_OPTION='--patch'
else
  if [ "${PLUGIN_UPDATE_ONLY_MINOR}" == 'y' ]; then
      PLUGIN_UPDATE_OPTION='--minor'
  fi
fi
for PLUGIN_NAME in $(~/bin/wp plugin list --update=available --field=name ${PLUGIN_UPDATE_CHECK_PARAM}); do
    ~/bin/wp plugin update ${PLUGIN_NAME} ${PLUGIN_UPDATE_OPTION}
done

THEME_UPDATE_CHECK_PARAM=''
if [ "${THEME_UPDATE_ONLY_ACTIVED}" == 'y' ]; then
    THEME_UPDATE_CHECK_PARAM='--status=active'
fi
echo '# -----------------------'
echo '# Theme Update Status'
echo '# -----------------------'
echo "wp theme list --update=available ${THEME_UPDATE_CHECK_PARAM}"
~/bin/wp theme list --update=available ${THEME_UPDATE_CHECK_PARAM}

for THEME_NAME in $(~/bin/wp theme list --update=available --field=name ${THEME_UPDATE_CHECK_PARAM}); do
    ~/bin/wp theme update ${THEME_NAME}
done
