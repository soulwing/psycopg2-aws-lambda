#!/bin/bash

BASE_DIR=$PWD
PG_DIR=postgresql-${PG_VER}
PSY_DIR=psycopg2-${PSY_VER}
PG_PREFIX=$BASE_DIR/build
DIST_FILE=$BASE_DIR/psycopg${PSY_VER_DOTS}-${PY_VER}.zip

# all non-zero exits are fatal
set -e

# build postgresql
pushd $PG_DIR
./configure --prefix=$PG_PREFIX --without-readline --without-zlib --with-openssl
make all install
popd

# configure psycopg2
pushd $PSY_DIR
PG_CONFIG=$PG_PREFIX/bin/pg_config
echo $PG_CONFIG
sed "s|^pg_config=.*|pg_config=$PG_CONFIG|; \
     s|^static_libpq=.*|static_libpq=1|;
     s|^libraries=.*|libraries=ssl crypto|" \
     < setup.cfg > setup.cfg.tmp
mv setup.cfg.tmp setup.cfg

# build psycopg2
python${PY_VER} setup.py build

# create distribution zip and hashes
pushd build/lib.linux-x86_64-${PY_VER}
zip -q -r $DIST_FILE psycopg2/*
sha256sum $DIST_FILE >$DIST_FILE.sha256
md5sum $DIST_FILE >$DIST_FILE.md5
cat $DIST_FILE.sha256
cat $DIST_FILE.md5
popd 

popd
exit 0
