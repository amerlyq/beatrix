#!zsh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: generate suggested testsuite for specified targets
#%USAGE: $ source ./$0
#%  $ GenerateTestsuite <nm> [[alias1,...]target1] ...
#%  e.g: $ GenerateTestsuite run t,test,ctest r,run
#%
set -o errexit -o noclobber -o nounset -o pipefail


function UnexpandPaths {
  set -- d_git d_btrx HOME
  sed "$(for v { print "s|${(P)v}\\\\b|\$$v|g" })"
}

# USAGE: $ GenerateTestcase [alias1,...]target [target_args]
function GenerateTestcase { local cmd tgts=$1; shift

  # ATT:("): https://stackoverflow.com/questions/35838392/duplicating-an-array-11-in-zsh
  #   https://stackoverflow.com/questions/19284296/how-to-assign-an-associative-array-to-another-variable-in-zsh
  tgts=("${(@s/,/)tgts}")
  cmd=${tgts[-1]}

  local output unexpanded errcode=0
  output=${${"$(DryrunTarget -- $cmd $@ 2>&1; print .)"%.}%$'\n'} || {
    errcode=$?
    print -u2 "Err($errcode): $ make $cmd $@"
    print -u2 $output
    exit $errcode
  }

  print
  (($#tgts>1)) && print -r "for x in $tgts" && cmd='$x'

  # ALT: if UnexpandPaths <<<$output | diff -q -- /dev/stdin /dev/fd/3  3<<<$output; then
  unexpanded=${${"$(UnexpandPaths <<<$output; print .)"%.}%$'\n'}

  # NOTE: auto-pick 'EOT' if body has no known path substitutions
  # NOTE: always strip trailing spaces from suggested testsuite
  if [[ $output == "$unexpanded" ]]; then
    print -r "CHECK $cmd${@:+ $*} <<'EOT'"
    sed 's/\s\+$//'
    print -r "EOT"
  else
    # NOTE: duplicate trailing "\" and escape every '$' inside
    print -r "CHECK $cmd${@:+ $*} <<EOT"
    sed 's/\s\+$//; s|[$]|\\&|g; s|\\$|\\&|' | UnexpandPaths
    print -r "EOT"
  fi <<< $output
}

function GenerateTestsuite {
  local nm=$1; shift

  print -r '#!/usr/bin/env zsh'

  # RENAME?(MIT.zsh): "copyright.zsh" with placeholders for "license" and "copyright" lines
  #   ALT:TRY: use "reuse addheader" for post-processing
  < ${0:h:h}/reuse/tmpl/MIT.zsh

<<EOT
#%SUMMARY: "$nm/make/ctl/zsh" testsuite
#%USAGE:
#%  $ ./\$0
#%  $ ./t/testsuite '$nm/*'
#%  $ m ts A='$nm/\\*'
#%  $ make test-self self.args='$nm/\\*'
#%  $ m tS N='$nm' A='$*'
#%
(( \${#functions[CHECK]-} )) || source \${0:A:h:h:h}/t/check.zsh
EOT

  for tgts { GenerateTestcase $tgts }
}
