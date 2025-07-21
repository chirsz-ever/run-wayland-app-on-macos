#!/usr/bin/env bash

set -e
# set -x

THIS_DIR=$(realpath "$(dirname "$0")")
INSTALL_PREFIX_DIR="${THIS_DIR}/fakeroot"

PATH="${PATH}:${INSTALL_PREFIX_DIR}/bin"

export CMAKE_PREFIX_PATH=$INSTALL_PREFIX_DIR
export PKG_CONFIG_PATH="$INSTALL_PREFIX_DIR/lib/pkgconfig:$INSTALL_PREFIX_DIR/share/pkgconfig"

compile_wayland() {
    pushd wayland

    meson setup \
        --prefix "$INSTALL_PREFIX_DIR" \
        -Dtests=false \
        -Ddocumentation=false \
        -Ddtd_validation=false \
        build
    meson compile -C build
    meson install -C build

    popd
}

compile_wayland-protocols() {
    pushd wayland-protocols

    meson setup \
        --prefix "$INSTALL_PREFIX_DIR" \
        -Dtests=false \
        build
    meson compile -C build
    meson install -C build

    popd
}

compile_owl() {
    pushd owl

    mkdir -p build && cd build

    export CFLAGS;
    CFLAGS=$(pkg-config --cflags wayland-server xkbcommon)
    export LDFLAGS;
    LDFLAGS=$(pkg-config --libs wayland-server xkbcommon)
    ../configure
    make

    popd
}

compile_havoc() {
    pushd havoc

    make

    popd
}

compile_all() {
    compile_wayland
    compile_wayland-protocols
    compile_owl
    compile_havoc
}

cd "$THIS_DIR"

if [[ $# == 0 ]]; then
    compile_all
elif [[ $1 == "-h" || $1 == "--help" || $1 == "help" ]]; then
    echo "Usage: ./build.sh [all|wayland|wayland-protocols|owl|havoc]"
else
    compile_"$1"
fi
