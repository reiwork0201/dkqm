FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y debootstrap qemu-user-static

ENV SYSROOT=/armel-rootfs
RUN mkdir -p $SYSROOT

# QEMUはGitHub Actions側で登録済みとして
RUN debootstrap --arch=armel --no-check-gpg bullseye $SYSROOT http://archive.debian.org/debian

# apt の期限切れ警告回避設定
RUN echo "deb http://archive.debian.org/debian bullseye main contrib non-free" > $SYSROOT/etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > $SYSROOT/etc/apt/apt.conf.d/99no-check-valid-until

RUN cp /usr/bin/qemu-arm-static $SYSROOT/usr/bin/
