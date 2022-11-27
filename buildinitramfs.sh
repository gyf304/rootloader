#!/bin/bash

dir="$PWD"

cd /tmp

rm -rf busybox-1.35.0
curl -sSL https://busybox.net/downloads/busybox-1.35.0.tar.bz2 | tar -xj
cd busybox-1.35.0

# Build busybox
cat > .config << EOF
CONFIG_STATIC=y
EOF
yes "" | make oldconfig
make CROSS_COMPILE=/opt/musl-cross/aarch64-linux-musl/bin/aarch64-linux-musl-
make install CROSS_COMPILE=/opt/musl-cross/aarch64-linux-musl/bin/aarch64-linux-musl-

# make busybox suid
chmod u+s _install/bin/busybox

install -Dm755 "$dir/bin/"* _install/bin/

# install some FHS directories
install -dm755 _install/{boot,mnt,tmp,root,etc,proc}

# install init
install -Dm755 "$dir/init" _install/init

cd _install
find . -print0 | cpio --null -ov --format=newc \
  | gzip -9 > "$dir/initramfs.cpio.gz"

