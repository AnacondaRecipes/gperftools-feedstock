#!/bin/bash
set -exo pipefail

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "$target_platform" == osx-* ]]; then
  export CFLAGS="$CFLAGS -D_XOPEN_SOURCE"
  ./configure --prefix="$PREFIX" --disable-libunwind
else
  if [[ $target_platform == *aarch64 ]]; then
    # to match PBP worker
    EXTRA=--with-tcmalloc-pagesize=64
  fi
  ./configure --prefix="$PREFIX" --enable-libunwind --enable-frame-pointers $EXTRA
fi

make -j"${CPU_COUNT}"

make check

make install
