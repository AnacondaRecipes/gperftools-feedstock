#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "$target_platform" == osx-* ]]; then
  export CFLAGS="$CFLAGS -D_XOPEN_SOURCE"
  ./configure --prefix="$PREFIX" \
    --disable-debugalloc \
    --disable-libunwind
else
  ./configure --prefix="$PREFIX" --enable-libunwind --enable-frame-pointers
fi

make -j"${CPU_COUNT}"

make check

make install
