#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY:
#%USAGE: $ ./$0
set -o errexit -o errtrace -o noclobber -o noglob -o nounset -o pipefail

d_img=_build-qemu-arm/images
kern=$d_img/zImage
img=$d_img/rootfs.squashfs
# dtb=$d_img/platform.dtb
# ram=$d_img/rootfs.cpio


exec qemu-system-arm -nographic -nodefaults -no-user-config -name QemuArm \
  -machine vexpress-a9 -smp cores=2 -m 256 \
  -audiodev id=none,driver=none \
  -kernel "$kern" -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0" \
  -drive file="$img",if=sd,format=raw -snapshot \
  -serial mon:stdio \
  -net user \
  -gdb tcp::1234 -S \
  # -writeconfig qemu.ini

# exec qemu-system-arm -nographic -nodefaults \
#   -M vexpress-a9 -smp 1 -m 256 \
#   -kernel "$kern" \
#   -dtb "$dtb" \
#   -drive file="$img",if=sd,format=raw \
#   -append "console=ttyS0,115200 rootwait root=/dev/mmcblk0p1" \
#   -audiodev pa,id=pa,server="$(pactl info|awk '/Server String/{print $3}')" \
#   -serial mon:stdio -net nic,model=lan9118 -net user \
#   -gdb tcp::1234 -S
