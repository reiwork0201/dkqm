FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    debootstrap \
    qemu-user-static \
    binutils-arm-linux-gnueabi \
    gcc-10-arm-linux-gnueabi \
    g++-10-arm-linux-gnueabi \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV SYSROOT=/armel-rootfs

RUN mkdir -p $SYSROOT

# QEMUバイナリはホスト側で登録済みなのでここでdebootstrapを実行可能
RUN debootstrap --arch=armel bullseye $SYSROOT http://deb.debian.org/debian

# qemu-arm-staticをrootfsにコピー（動作テスト用）
RUN cp /usr/bin/qemu-arm-static $SYSROOT/usr/bin/

WORKDIR /work
CMD ["/bin/bash"]
