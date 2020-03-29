#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
exec qemu-system-arm -s -S -M virt -smp 1 \
  -nographic -monitor none -serial stdio \
  -kernel arch/arm/boot/zImage \
  -initrd core-image-minimal-qemuarm.cpio_.gz \
  -append "console=ttyAMA0 earlycon earlyprintk"
