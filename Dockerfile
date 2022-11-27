FROM debian:bullseye-slim
# https://busybox.net/downloads/busybox-1.35.0.tar.bz2

RUN apt-get update && apt-get install -y \
	git curl wget bzip2 gzip cpio build-essential ncurses-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN git clone https://github.com/richfelker/musl-cross-make.git

WORKDIR /root/musl-cross-make

RUN make -j $(nproc) TARGET=aarch64-linux-musl
RUN make install OUTPUT=/opt/musl-cross/aarch64-linux-musl TARGET=aarch64-linux-musl

RUN make -j $(nproc) TARGET=arm-linux-musleabi
RUN make install OUTPUT=/opt/musl-cross/arm-linux-musleabi TARGET=arm-linux-musleabi

RUN make -j $(nproc) TARGET=riscv64-linux-musl
RUN make install OUTPUT=/opt/musl-cross/riscv64-linux-musl TARGET=riscv64-linux-musl

RUN make -j $(nproc) TARGET=mips-linux-musl
RUN make install OUTPUT=/opt/musl-cross/mips-linux-musl TARGET=mips-linux-musl

RUN make -j $(nproc) TARGET=mipsel-linux-musl
RUN make install OUTPUT=/opt/musl-cross/mipsel-linux-musl TARGET=mipsel-linux-musl

RUN make -j $(nproc) TARGET=x86_64-linux-musl
RUN make install OUTPUT=/opt/musl-cross/x86_64-linux-musl TARGET=x86_64-linux-musl

RUN make -j $(nproc) TARGET=i686-linux-musl
RUN make install OUTPUT=/opt/musl-cross/i686-linux-musl TARGET=i686-linux-musl

WORKDIR /root
