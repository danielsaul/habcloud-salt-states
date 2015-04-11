#!/bin/sh
set -xe
TAR="tar --no-same-permissions --no-same-owner"

mkdir /srv/ukhas-dokuwiki # must not exist already

rm -f /tmp/dokuwiki-stable.tgz /tmp/dokuwiki-recaptcha.tgz
wget -qO /tmp/dokuwiki-stable.tgz    http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
wget -qO /tmp/dokuwiki-recaptcha.tgz https://github.com/liip/dw-plugin-recaptcha/archive/master.tar.gz
$TAR -xf /tmp/dokuwiki-stable.tgz    -C /srv/ukhas-dokuwiki --strip-components=1
mkdir /srv/ukhas-dokuwiki/lib/plugins/recaptcha
$TAR -xf /tmp/dokuwiki-recaptcha.tgz -C /srv/ukhas-dokuwiki/lib/plugins/recaptcha --strip-components=1

rm -rf /srv/ukhas-dokuwiki/data /srv/ukhas-dokuwiki/install.php
ln -s /srv/ukhas-data/users.auth.php /srv/ukhas-dokuwiki/conf
ln -s /srv/ukhas-data/data           /srv/ukhas-dokuwiki/
