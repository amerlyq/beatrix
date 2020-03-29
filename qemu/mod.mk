#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
$(call &AssertVars,d_pj bdir &here)

qemu_exe = $(shell which qemu-system-arm)
qemu_cfg = $(&here)/config.ini
# OR: qemu_cfg = $(br2set)/qemu.ini
@br2bootimgs := $(foreach 1,$(filter br2fs_% br2kern_%,$(.VARIABLES)),$(value $1))


.PHONY: qe qg qu
#%ALIAS: [qemu]     # run foreign executables in qemu
qe: qemu-run        # … run buildroot images in qemu
qg: qemu-gdb-kernel # … run buildroot images in qemu with gdbserver to debug kernel
qu: qemu-run-user   # … run single foreign exe in user-mode qemu


qemu-gdb-kernel: override qemu_args += -gdb tcp::1234 -S
qemu-gdb-kernel: qemu-run


qemu-run: $(qemu_cfg) $(@br2bootimgs) | $(qemu_exe)
	@'$|' -nographic -nodefaults -no-user-config -readconfig '$<' \
	  -kernel '$(br2kern_img)' -dtb '$(br2kern_dtb)' -initrd '$(br2fs_ramfs)' \
	  $(qemu_args) -snapshot -audiodev id=none,driver=none -serial mon:stdio
