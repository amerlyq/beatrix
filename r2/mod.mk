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
r2r: r2-rr          # … replay



.PHONY: r2-debug
r2-debug: run.wrap += r2 -d
r2-debug: run



# TODO:ALSO: attach to RR replay image
.PHONY: r2-rr
r2-rr: run.wrap += r2 -D gdb gdb://host:port
r2-rr: run


# TRY: attach to Qemu/GDB
