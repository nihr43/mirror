#!/bin/sh
#
# create local copies of freebsd source code via svn

[ "$1" == "now" ] || sleep `jot -r 1 0 3600`

[ -f "/var/mirror_update.lock" ] && {
  logger "Source update failed due to lock"
  exit 1
}

touch /var/freebsd-src_update.lock
logger "Updating source"

DIR='/usr/src'
REPOS='base/head base/release base/stable' #csrg doc ports socsvn'

for i in $REPOS; do
  [ -d "$DIR/$i" ] || {
    mkdir -p  $DIR/$i
  }
done

for i in $REPOS; do
  [ -d "$DIR/$i/.svn" ] || {
    svnlite checkout https://svn.freebsd.org/$i/ $DIR/$i/
  } && {
    svnlite cleanup $DIR/$i/
    svnlite update $DIR/$i/
  }
done

rm /var/freebsd-src_update.lock
