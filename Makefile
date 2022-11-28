.PHONY: clean all docker

DOCKER_IMAGE?=gyf304/musl-cross

all: out/initramfs.aarch64.cpio.gz out/initramfs.arm.cpio.gz out/initramfs.x86_64.cpio.gz out/initramfs.i686.cpio.gz out/initramfs.mips.cpio.gz out/initramfs.mipsel.cpio.gz

docker: Dockerfile
	docker build -t $(DOCKER_IMAGE) .

build:
	mkdir -p build

build/busybox-1.35.0.tar.bz2:
	curl -O https://busybox.net/downloads/busybox-1.35.0.tar.bz2

out:
	mkdir -p out

out/initramfs.aarch64.cpio.gz: out build/busybox-1.35.0.tar.bz2
	docker rm initramfs-builder-aarch64 || true
	docker run --name=initramfs-builder-aarch64 -v "$$PWD:/mnt" $(DOCKER_IMAGE) bash -c "cd /mnt && CROSS_COMPILE=/opt/musl-cross/aarch64-linux-musl/bin/aarch64-linux-musl- ./build.sh"
	docker cp initramfs-builder-aarch64:/tmp/initramfs.cpio.gz out/initramfs.aarch64.cpio.gz
	docker rm initramfs-builder-aarch64

out/initramfs.arm.cpio.gz: out
	docker rm initramfs-builder-arm || true
	docker run --name=initramfs-builder-arm -v "$$PWD:/mnt" $(DOCKER_IMAGE) bash -c "cd /mnt && CROSS_COMPILE=/opt/musl-cross/arm-linux-musleabi/bin/arm-linux-musleabi- ./build.sh"
	docker cp initramfs-builder-arm:/tmp/initramfs.cpio.gz out/initramfs.arm.cpio.gz
	docker rm initramfs-builder-arm

out/initramfs.x86_64.cpio.gz: out
	docker rm initramfs-builder-x86_64 || true
	docker run --name=initramfs-builder-x86_64 -v "$$PWD:/mnt" $(DOCKER_IMAGE) bash -c "cd /mnt && CROSS_COMPILE=/opt/musl-cross/x86_64-linux-musl/bin/x86_64-linux-musl- ./build.sh"
	docker cp initramfs-builder-x86_64:/tmp/initramfs.cpio.gz out/initramfs.x86_64.cpio.gz
	docker rm initramfs-builder-x86_64

out/initramfs.i686.cpio.gz: out
	docker rm initramfs-builder-i686 || true
	docker run --name=initramfs-builder-i686 -v "$$PWD:/mnt" $(DOCKER_IMAGE) bash -c "cd /mnt && CROSS_COMPILE=/opt/musl-cross/i686-linux-musl/bin/i686-linux-musl- ./build.sh"
	docker cp initramfs-builder-i686:/tmp/initramfs.cpio.gz out/initramfs.i686.cpio.gz
	docker rm initramfs-builder-i686

out/initramfs.mips.cpio.gz: out
	docker rm initramfs-builder-mips || true
	docker run --name=initramfs-builder-mips -v "$$PWD:/mnt" $(DOCKER_IMAGE) bash -c "cd /mnt && CROSS_COMPILE=/opt/musl-cross/mips-linux-musl/bin/mips-linux-musl- ./build.sh"
	docker cp initramfs-builder-mips:/tmp/initramfs.cpio.gz out/initramfs.mips.cpio.gz
	docker rm initramfs-builder-mips

out/initramfs.mipsel.cpio.gz: out
	docker rm initramfs-builder-mipsel || true
	docker run --name=initramfs-builder-mipsel -v "$$PWD:/mnt" $(DOCKER_IMAGE) bash -c "cd /mnt && CROSS_COMPILE=/opt/musl-cross/mipsel-linux-musl/bin/mipsel-linux-musl- ./build.sh"
	docker cp initramfs-builder-mipsel:/tmp/initramfs.cpio.gz out/initramfs.mipsel.cpio.gz
	docker rm initramfs-builder-mipsel

clean:
	rm -rf out
