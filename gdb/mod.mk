#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: wrap app by GDB for runtime debugging
#%

## NEED: rebuild with debug symbols/src for dependent system packages
#   https://wiki.archlinux.org/index.php/Debug_-_Getting_Traces
## ALT: build e.g. "musl" for your project and link statically
#   FIND: will it help for MinGW/Android builds to distribute your own libc ?


.PHONY: g gdb
#%ALIAS: [debug]
g: gdb
gdb: gdb-run


#%DEPS:|extra/gdb|
.PHONY: gdb-run
gdb-run: run.wrap += gdb -q --args
gdb-run: run
