#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY:
#%USAGE: $ ./$0
set -o errexit -o errtrace -o noclobber -o noglob -o nounset -o pipefail

# btype=$1
# shift

gdb='gdb-multiarch'
d_linux=_build-common/build/linux-custom
# d_linux=_build-qemu/build/linux-5.4.23

exec "$gdb" -q \
  -iex "set gnutarget elf32-littlearm" \
  -ex "set directories \$cdir:\$cwd:$d_linux" \
  -ex 'target remote :1234' \
  "$@" --args $d_linux/vmlinux
