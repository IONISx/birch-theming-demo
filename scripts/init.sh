#!/usr/bin/env bash

fail() { echo "[-] $@"; exit 1; }
log() { echo "[+] $@"; }

cd /edx/app/edxapp/themes/ionisx

echo

log "Install IONISx theme development dependencies"
npm install && bower install \
    && log Done \
    || fail Failed

echo

log "Build theme"
grunt build \
    && log Done \
    || fail Failed

echo

log "Update Open edX LMS assets"
/edx/bin/edxapp-update-assets-lms \
    && log Done \
    || fail Failed

echo

log "Set staff as superuser"
echo "update auth_user set is_superuser=1 where username='staff'" \
    | mysql -u root edxapp \
    && log Done \
    || fail Failed

echo

log "Update darklang config"
echo "insert into dark_lang_darklangconfig set change_date=curtime(), changed_by_id=1, enabled=1, released_languages='en,fr';" \
    | mysql -u root edxapp \
    && log Done \
    || fail Failed

echo

log "Run asset watcher"
pkill -9 grunt
nohup grunt > theme.log 2> theme.err < /dev/null &
