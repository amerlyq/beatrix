.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

Update configs
==============

TODO: write how to save/update only "fragments"

Buildroot::

   make nconfig
   make savedefconfig

BUG:(savedefconfig):
   NICE: correctly modified ./ext/board/qemu-arm/defconfig
   FAIL: symlink replaced by copy of whole file ./ext/configs/btrx_qemu-arm_defconfig

Linux::

   make linux-nconfig
   make linux-update-defconfig

Busybox::

   make busybox-nconfig
   make busybox-update-config
