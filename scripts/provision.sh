fail() { echo "[-] $@"; exit 1; }
log() { echo "[+] $@"; }

echo

log "Enable template debug"
sed -i \
    -e 's/DEBUG = False/DEBUG = True/' \
    /edx/app/edxapp/edx-platform/lms/envs/aws.py \
    && log Done \
    || fail Failed

echo

log "Change langage"
sed -i \
    -e 's/"LANGUAGE_CODE": "en"/"LANGUAGE_CODE": "fr"/' \
    /edx/app/edxapp/*.env.json \
    && log Done \
    || fail Failed

log "Fix static URL patterns"
sed -i \
    's%urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)%urlpatterns += patterns("staticfiles.views", url(r"^static/(?P<path>.*)$", "serve"))%' \
    /edx/app/edxapp/edx-platform/lms/urls.py \
    && log Done \
    || fail Failed

echo

log "Disable advanced security"
echo "FEATURES['ADVANCED_SECURITY'] = False" \
    >> /edx/app/edxapp/edx-platform/lms/envs/aws.py \
    && log Done \
    || fail Failed

echo

log "Allow concurrent logins"
echo "FEATURES['PREVENT_CONCURRENT_LOGINS'] = False" \
    >> /edx/app/edxapp/edx-platform/lms/envs/aws.py \
    && log Done \
    || fail Failed


log "Enable custom theming"
sed -i \
    -e 's/"USE_CUSTOM_THEME": false/"USE_CUSTOM_THEME": true/' \
    -e 's/"THEME_NAME": ""/"THEME_NAME": "ionisx"/' \
    /edx/app/edxapp/lms.env.json \
    && log Done \
    || fail Failed

echo

log "Disable nginx statics"
sed -i \
    's:/static:/dstatic:g' \
    /etc/nginx/sites-enabled/lms \
    && service nginx reload \
    && log Done \
    || fail Failed

echo

log "Disable static collection"
sed -i \
    's/lms --settings/lms --skip-collect --settings/' \
    /edx/bin/edxapp-update-assets-lms \
    && log Done \
    || fail Failed

echo

log "Restart Open edX LMS"
/edx/bin/supervisorctl restart edxapp:lms \
    && log Done \
    || fail Failed

echo

log "Update npm"
npm install -g npm \
    && log Done \
    || fail Failed

echo

log "Install global node modules"
npm install -g bower grunt-cli \
    && log Done \
    || fail Failed
