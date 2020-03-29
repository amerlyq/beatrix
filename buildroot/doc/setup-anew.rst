.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

Setup buildroot anew
====================

NOTE: must do all instructions from zero

* Download latest release of buildroot

* Download latest stable kernel (backport)

    + https://www.kernel.org/
    + https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.27.tar.xz

* Copy latest default configs::

    cp …/linux/arch/arm/configs/vexpress_defconfig ./buildroot/ext/board/qemu-arm/linux.config

* Update (re-save) configs by actually expected ones::

    READ: update-configs.rst
