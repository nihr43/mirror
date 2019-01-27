#!/bin/sh
#
# create local copies of freebsd source code via svn

sleep `jot -r 1 0 14400`

[ -f "/var/mirror_update.lock" ] && exit 1

touch /var/freebsd-src_update.lock

DIR='/usr/src'
REPOS='base' #csrg doc ports socsvn'

for i in $REPOS; do
  [ -d "$DIR/$i" ] || {
    mkdir $DIR/$i
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
