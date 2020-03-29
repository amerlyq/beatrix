#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: wrap app by GDB for runtime debugging
#%
$(call &AssertVars,d_pj br2kern_dir O &here)

## NEED: rebuild with debug symbols/src for dependent system packages
#   https://wiki.archlinux.org/index.php/Debug_-_Getting_Traces
## ALT: build e.g. "musl" for your project and link statically
#   FIND: will it help for MinGW/Android builds to distribute your own libc ?

gdb_exe = gdb-multiarch
gdb_arch = elf32-littlearm
gdb_cfg = $(&here)gdbinit
gdb_dbg = $(O)/debuginfo/usr/lib/debug

gdb_cmd =
gdb_cmdargs =
gdb_core =
# ALT:(set directories):THINK:USE: $ gdb -cd='$(gdb_src)'
gdb_src =


.PHONY: g gdb gc gk gm gq
#%ALIAS: [debug]
g: gdb
gdb: gdb-run
gc: gdb-core
gk: gdb-kernel
gm: gdb-multi
gq: gdb-qemu


#%DEPS:|extra/gdb|
.PHONY: gdb-run
gdb-run: run.wrap += gdb -q --args
gdb-run: run



# MOVE? all below into sep <integ> feature: gdb-qemu OR qemu-gdb
.PHONY: gdb-core
gdb-core: gdb_src := $(d_pj)
gdb-core: gdb-multi


# [_] FIXME:BET: directly install vmlinux into images, don't create zImage
.PHONY: gdb-kernel
gdb-kernel: gdb_cmd := $(br2kern_dir)/vmlinux
gdb-kernel: gdb_src := $(br2kern_dir)
gdb-kernel: override gdb_args += -ex 'target remote :1234'
gdb-kernel: gdb-multi


.PHONY: gdb-qemu
gdb-qemu: gdb_src := $(O)/build
gdb-qemu: gdb-multi


## ALT:(gdb_cmdline):
# ifeq ($(gdb_cmd),$(subst /,,$(gdb_cmd)))
# override gdb_cmd := $(O)/target/usr/bin/$(gdb_cmd)
# endif
.PHONY: gdb-multi
gdb-multi: gdb_cmdline = '$(if $(findstring /,$(gdb_cmd)),,$(O)/target/usr/bin/)$(gdb_cmd)'
gdb-multi: gdb_cmdline += $(if $(gdb_core),'$(gdb_core)',$(gdb_cmdargs))
gdb-multi:
	$(gdb_exe) -q -iex 'set gnutarget $(gdb_arch)' $(if $(gdb_cfg),-x '$(gdb_cfg)') \
	  -ex 'set debug-file-directory $(gdb_dbg)' \
	  -ex 'set directories $$cdir:$$cwd:$(gdb_src)' \
	  $(gdb_args) $(if $(gdb_core),--,--args) $(gdb_cmdline)
