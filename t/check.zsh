#!zsh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: testsuite functions
#%USAGE: $ source ./$0 ["grp/t/lang-sys"]
#%  $ CHECK [-"testname/description"] make_tgts <<< "EXPECTED unified output"
#%
set -o errexit -o noclobber -o nounset -o pipefail

(( $#commands[${make::=remake}] ))    || (( $#commands[${make::=make}] ))
(( $#commands[${diff::=colordiff}] )) || (( $#commands[${diff::=diff}] ))

# ALT?("(%)"): "ZSH_ARGZERO" :: https://stackoverflow.com/questions/35677745/zsh-get-filename-of-the-script-that-called-a-function
# BUT: "$0" inside sourced script -- is path to that script, not main executable ?
#   ??? FIND: what the difference between "$0" and "${(%)}"
d_btrx=${${(%):-%x}:A:h:h}

# NOTE: mock-like ifc -- expect all called cmds printed in determined order
function DRYRUN {
  # ALT: $make SHELL='printf' .SHELLFLAGS='%s\\n' $@ |& sed "s|$d_btrx|:|g"
  $make --dry-run --silent \
    --no-builtin-rules --no-builtin-variables --no-print-directory \
    --directory=$d_btrx \
    --file=$d_btrx/t/main.mk \
    -I $d_btrx \
    -I $d_btrx/make \
    $@ \
  |& sed "s|$d_btrx|:|g"
}

# NOTE: when $1 is "-..." use it as testname (description)
function CHECK { local out; ((++testindex))
  local nm="$testgroup/$testlang/$testsys/$testindex"
  [[ $1 == -* ]] && nm+=/${1:1} && shift
  [[ $1 == -- ]] && shift
  [[ $nm != ${~testfilter:-*} ]] && return

  printf '[%s] $ %s\n' $nm "$make $*"
  out=$(DRYRUN -- $@)

  # INFO: on error print "/path/to/test:lnum" pointing to calling function (to verify text for comparison)
  #   SRC: https://unix.stackexchange.com/questions/453144/functions-calling-context-in-zsh-equivalent-of-bash-caller
  $diff --color=auto \
    --unified=0 \
      --label "EXPECT ${funcfiletrace[1]:A}" \
      --label ACTUAL \
    -- /dev/stdin /dev/fd/3  3<<<$out
}

# NOTE: define current global test group from path to testfile
#   e.g. tests for my custom "make IDE ctl" and underlying "make buildsystem integration"
function GROUP {
  testindex=0
  testfile=$1                       # INFO: /path/to/beatrix/<mod>/t/<lang>-<sys>.zsh
  testgroup=${testfile:h:h:t}       # VIZ: beatrix/* (top-level dirs)
  testlang=${${testfile:t:r}%%-*}   # VIZ: cmake, make, d, rust, zsh
  testsys=${${testfile:t:r}#*-}     # VIZ: ctl, ide, mod
}

GROUP ${1:-${ZSH_ARGZERO:A}}
