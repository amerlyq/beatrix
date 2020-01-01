#!/usr/bin/env zsh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: "hooks/make/ctl/zsh" testsuite
#%USAGE:
#%  $ ./$0
#%  $ ./t/testsuite 'hooks/*'
#%  $ m ts A='hooks/\*'
#%  $ make test-self self.args='hooks/\*'
#%  $ m tS N='hooks' A='hooks-install hkc,hooks-pre-commit hkp,hooks-pre-push'
#%
(( ${#functions[CHECK]-} )) || source ${0:A:h:h:h}/t/check.zsh

CHECK hooks-install <<EOT
install -vCDm755 -t '$d_git/hooks' -- \\
  '$d_btrx/make/pre-commit' '$d_btrx/make/pre-push'
EOT

for x in hkc hooks-pre-commit
CHECK $x <<'EOT'
'hooks/pre-commit'
EOT

for x in hkp hooks-pre-push
CHECK $x <<'EOT'
'hooks/pre-push'
EOT
