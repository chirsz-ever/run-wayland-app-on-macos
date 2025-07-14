Before building, you need install `epoll-shim` and `xkbcommon`. You can easily install them by [Homebrew](https://brew.sh).

Build Steps:

1. Prepare the repository

```sh
git clone https://github.com/chirsz-ever/run-wayland-app-on-macos.git
cd run-wayland-app-on-macos
git submodule update --init --filter=blob:none
```

2. Build and install to `fakeroot`

```sh
./build.sh
```

3. Run

```sh
export XDG_RUNTIME_DIR="/tmp"
./owl/build/Owl.app/Contents/MacOS/Owl &
./havoc/build/havoc
```
