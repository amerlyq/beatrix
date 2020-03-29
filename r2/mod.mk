#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: run app under radare2
#%DEPS:|community/radare2|
#%

.PHONY: r2
#%ALIAS: [debug]    # run process in radare2
r2: r2-debug        # … debugging
r2k: r2-kernel      # … attach to Linux kernel inside qemu
r2r: r2-rr          # … replay



.PHONY: r2-debug
r2-debug: run.wrap += r2 -d
r2-debug: run



# TODO:ALSO: attach to RR replay image
.PHONY: r2-rr
r2-rr: run.wrap += r2 -D gdb gdb://host:port
r2-rr: run


#%SUMMARY: attach to Qemu/GDB ⌇⡞⡱⣿⡣
#%USAGE: Remote GDB · Radare2 Book ⌇⡞⡻⡹⡡
#   https://radare.gitbooks.io/radare2book/debugger/remote_gdb.html
#%BAD: no hbreak for r2 to stop on start_kernel()
#   https://github.com/radareorg/radare2/issues/11482
.PHONY: r2-kernel
r2-kernel: r2_gdb := gdb://localhost:1234
r2-kernel: r2_cmd := $(br2kern_dir)/vmlinux
r2-kernel: r2_src := $(br2kern_dir)
r2-kernel:
	r2 -a arm -B 0x80000000 -D gdb '$(r2_gdb)' $(if $(r2_cfg),-i '$(r2_cfg)') \
      -e dbg.exe.path='$(r2_cmd)' $(r2_args)
