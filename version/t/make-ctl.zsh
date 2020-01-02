#!/usr/bin/env zsh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: "version/make/ctl/zsh" testsuite
#%USAGE:
#%  $ ./$0
#%  $ ./t/testsuite 'version/*'
#%  $ m ts A='version/\*'
#%  $ make test-self self.args='version/\*'
#%  $ m tS N='version' A='ver,version version-full VERSION'
#%
(( ${#functions[CHECK]-} )) || source ${0:A:h:h:h}/t/check.zsh

for x in ver version
CHECK $x <<EOT
'version/from-git' '$d_btrx/t' only
EOT

CHECK version-full <<EOT
'version/from-git' '$d_btrx/t'
EOT

CHECK VERSION <<EOT
'version/from-git' '$d_btrx/t' > 'VERSION.tmp'
mv -fT -- 'VERSION.tmp' 'VERSION'
EOT
