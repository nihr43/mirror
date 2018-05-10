#!/bin/sh
#
# create local copies of freebsd source code via svn

if [ -f "/var/mirror_update.lock" ]; then
	exit 1
fi

touch /var/freebsd-src_update.lock

DIR='/usr/src'
REPOS='base' #csrg doc ports socsvn'

for i in $REPOS; do
	if [ ! -d "$DIR/$i" ]; then
		mkdir $DIR/$i
	fi
done

for i in $REPOS; do
        if [ ! -d "$DIR/$i/.svn" ]; then
                svnlite checkout https://svn.freebsd.org/$i/ $DIR/$i/
	else
		svnlite update https://svn.freebsd.org/$i/ $DIR/$i/
	fi
done

rm /var/freebsd-src_update.lock
