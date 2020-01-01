#!/usr/bin/env zsh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: "rr/make/ctl/zsh" testsuite
#%USAGE:
#%  $ ./$0
#%  $ ./t/testsuite 'rr/*'
#%  $ m ts A='rr/\*'
#%  $ make test-self self.args='rr/\*'
#%  $ m tS N='rr' A='rr,rr-record rg,rr-gdb rp,rr-play'
#%
(( ${#functions[CHECK]-} )) || source ${0:A:h:h:h}/t/check.zsh

for x in rr rr-record
CHECK $x <<EOT
cmake    -S'$d_btrx/t' -B'_build-clang-Debug' \\
  -G'Ninja' \\
  -C'$d_btrx/cmake/config/default.cmake' \\
  -DCMAKE_TOOLCHAIN_FILE='$d_btrx/cmake/toolchain/x86_64-pc-linux-gnu.cmake' \\
  -DCMAKE_INSTALL_PREFIX='_build-clang-Debug/_install' \\
  -DCMAKE_BUILD_TYPE='Debug' \\
  -DBUILD_TESTING='ON' \\
  -DUSE_COVERAGE='main' \\
  -DUSE_SANITIZERS='' \\

touch -- '_build-clang-Debug/--configure--'
install -vCDm755 -t '$d_git/hooks' \\
  -- '$d_btrx/hooks/pre-push' '$d_btrx/hooks/pre-commit'
cmake --build '_build-clang-Debug' \\
   \\
   \\
  --target run.main \\

EOT

for x in rg rr-gdb
CHECK $x <<'EOT'
rr --mark-stdio replay --debugger-option='-quiet'
EOT

for x in rp rr-play
CHECK $x <<'EOT'
rr --mark-stdio replay -a
EOT
