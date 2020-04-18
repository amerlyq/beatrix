#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: different output per "br2cfg" -- because it depends on buildroot defconfig
#%
$(call &AssertVars,O)

## BAD: hard to find correct folder with sources RENAME br2kern_src
# br2kern_dir := $(O)/build/linux-custom
# br2kern_dir := $(O)/per-package/linux
br2kern_dir := $(O)/build/linux-5.4.23

## CHECK: zImage builds longer BUT! debug vmlinux size >100MB and it longer copies
#  FAIL: zImage (and Image) are built anyway inside ./output/build/linux-*/arch/arm/boot
#  BUT:NICE: fixed path to vmlinux for gdb BAD: gdb anyway need path to sources
# br2kern_img := $(O)/images/vmlinux
# br2kern_img := $(br2kern_dir)/arch/arm/boot/Image
# br2kern_img := $(br2kern_dir)/vmlinux
br2kern_img := $(O)/images/zImage

## WARN: if you enable BR2_LINUX_KERNEL_DTB_IS_SELF_BUILT=y it won't be copied to images/
# br2kern_dtb := $(br2kern_dir)/arch/arm/boot/dts/vexpress-v2p-ca9.dtb
br2kern_dtb := $(O)/images/vexpress-v2p-ca9.dtb

br2fs_ramfs := $(O)/images/rootfs.cpio
