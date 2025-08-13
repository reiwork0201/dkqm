FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    debootstrap \
    qemu-user-static \
    binfmt-support \
    gcc-10-arm-linux-gnueabi \
    g++-10-arm-linux-gnueabi \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV SYSROOT=/armel-rootfs

RUN mkdir -p $SYSROOT

# armelのrootfsをdebootstrapで作成
RUN debootstrap --arch=armel bullseye $SYSROOT http://deb.debian.org/debian

# qemu-arm-staticをrootfsにコピーし、エミュレーション環境構築
RUN cp /usr/bin/qemu-arm-static $SYSROOT/usr/bin/

# binfmt_miscを有効にし、x86_64ホストからarmelバイナリを自動的にqemuで動かせるように設定
RUN update-binfmts --enable qemu-arm

# chroot環境内で簡単に動かすためにqemuをセット
ENV PATH=$SYSROOT/usr/bin:$PATH

WORKDIR /work

CMD ["/bin/bash"]
