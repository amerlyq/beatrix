#!/usr/bin/env zsh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
(( $#functions[CHECK] )) || source ${0:A:h:h:h}/t/check.zsh

CHECK tree <<'EOT'
tree --noreport -aAC --prune --matchdirs --dirsfirst \
  -I '_*|.*' -- . | sed -rz 's/\n?$/\n/'
EOT
