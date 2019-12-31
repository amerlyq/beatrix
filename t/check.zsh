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

colorize=
[[ -t 1 ]] && colorize=1
((${COLOR_ALWAYS:+1})) && colorize=1


(( $#commands[${make::=remake}] )) || (( $#commands[${make::=make}] ))
((colorize)) && (( $#commands[${diff::=colordiff}] )) || (( $#commands[${diff::=diff}] ))


# ALT?("(%)"): "ZSH_ARGZERO" :: https://stackoverflow.com/questions/35677745/zsh-get-filename-of-the-script-that-called-a-function
# BUT: "$0" inside sourced script -- is path to that script, not main executable ?
#   ??? FIND: what the difference between "$0" and "${(%)}"
d_btrx=${${(%):-%x}:A:h:h}
d_git=$(git rev-parse --git-dir)
numpassed=0
numfailed=0


# NOTE: mock-like ifc -- expect all called cmds printed in determined order
function DRYRUN {
  # ALT: $make SHELL='printf' .SHELLFLAGS='%s\\n' $@ |& sed "s|$d_btrx|:|g"
  $make --dry-run --silent \
    --no-builtin-rules --no-builtin-variables --no-print-directory \
    --directory=$d_btrx \
    --file=$d_btrx/t/main.mk \
    -I $d_btrx \
    -I $d_btrx/make \
    $@
}

# NOTE: when $1 is "-..." use it as testname (description)
function CHECK { local nm expect output errcode=0 errdiff=0
  ((++testindex))
  nm="$testgroup/$testlang/$testsys/$testindex"
  [[ $1 == -* ]] && nm+=/${1:1} && shift
  [[ $1 == -- ]] && shift
  [[ $nm != ${~testfilter:-*} ]] && return

  # DEV: add colors based on passed/failed tests
  if ((colorize)); then
    print -rPf '%s[%s]%s $ %s\n' '%K{default}%F{green}%B' $nm '%b%f%k' "$make $*"
  else
    print -rf '[%s] $ %s\n' $nm "$make $*"
  fi

  expect=$(cat)
  output=$(DRYRUN -- $@ 2>&1) || errcode=$?

  # NOTE: showing diff in reversed order to highlight _what you must change_ to fix the problem
  #   ALSO: to highlight "output" output in RED and place it before "expected"
  # INFO: on error print "/path/to/test:lnum" pointing to calling function (to verify text for comparison)
  #   SRC: https://unix.stackexchange.com/questions/453144/functions-calling-context-in-zsh-equivalent-of-bash-caller
  # FIXME: if COLOR_ALWAYS==1 then use "diff --color=always" instead of colordiff (it has bug and unexpectedly disables color)
  # EXPL:(--ignore-trailing-space): trailing spaces are stripped from testfiles anyway
  #   ALSO: --ignore-space-change --ignore-all-space --suppress-blank-empty
  $diff --color=auto --unified=0 \
    --ignore-tab-expansion \
    --ignore-trailing-space \
    --ignore-blank-lines \
    --label "FAILED errcode=$errcode" \
    --label "EXPECT ${funcfiletrace[1]:A}" \
    -- /dev/fd/3  3<<<$output \
       /dev/fd/4  4<<<$expect \
    || { errdiff=$?
      # ENH: only print when VERBOSE=1 OR GENERATE=1
      print -P '%F{10}'
      print -r "CHECK $* <<'EOT'"
      print -r $output
      print -P "EOT\n%f\n---"
    }

  # NOTE: global statistics for summary
  (( (errcode||errdiff) ? ++numfailed : ++numpassed))
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

function SUMMARY {
  if ((colorize)); then
    print -Pf ' %s:SUMMARY:%s %s%d%s passed, %s%d%s failed\n' \
      '%{%F{62}%B%}' '%{%b%f%}' \
      '%{%F{green}%}' $numpassed '%{%f%}' \
      '%{%F{red}%}' $numfailed '%{%f%}'
  else
    print " :SUMMARY: $numpassed passed, $numfailed failed"
  fi
  exit $(( !!numfailed ))
}

function PRETTY { sed -u "
  s|$d_btrx|:|g
  s|$HOME|~|g
"; }


export TESTSUITE=1
[[ -t 1 ]] && exec > >(PRETTY)
GROUP ${1:-${ZSH_ARGZERO:A}}
trap SUMMARY EXIT
