.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

board
=====

Full configs here.

Change relative symlink `default` when you want to use another board config by default project-wide.

HACK: when setting up new platform (e.g. QEMU "virt") use `multi_v7_defconfig` config as the default ARM config, and then disable all unnecessary parts.
NOTE: default "make defconfig" in kernel=5.4 picks something very similar, but you must manually pick `multi_v7_defconfig` for kernel=3.14.
