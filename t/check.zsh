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
(( ${#functions[GenerateTestcase]-} )) || source ${0:h}/gen.zsh

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
diffunified=1


# NOTE: mock-like ifc -- expect all called cmds printed in determined order
function DryrunTarget {
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

  # REF:(<): http://www.zsh.org/mla/users/2006/msg00066.html
  # REF:("): https://unix.stackexchange.com/questions/68694/when-is-double-quoting-necessary
  # HACK:(.): strip only *single* newline instead of all of them
  #   <= further "<<<" herestring operator will add that single newline back
  #   ALT:TRY:(.): use trailing space "print ' '" and don't strip it -- allow diff(1) to ignore it
  expect=${${"$(</dev/stdin; print .)"%.}%$'\n'}
  output=${${"$(DryrunTarget -- $@ 2>&1; print .)"%.}%$'\n'} || errcode=$?

  # NOTE: showing diff in reversed order to highlight _what you must change_ to fix the problem
  #   ALSO: to highlight "output" output in RED and place it before "expected"
  # INFO: on error print "/path/to/test:lnum" pointing to calling function (to verify text for comparison)
  #   SRC: https://unix.stackexchange.com/questions/453144/functions-calling-context-in-zsh-equivalent-of-bash-caller
  # FIXME: if COLOR_ALWAYS==1 then use "diff --color=always" instead of colordiff (it has bug and unexpectedly disables color)
  # EXPL:(--ignore-trailing-space): trailing spaces are stripped from testfiles anyway
  #   ALT: --ignore-space-change --ignore-all-space --suppress-blank-empty
  #   BAD:(--ignore-blank-lines): totally ignores any empty lines in testdata
  $diff --color=auto \
    --unified=$diffunified \
    --ignore-tab-expansion \
    --ignore-trailing-space \
    --label "FAILED errcode=$errcode" \
    --label "EXPECT ${funcfiletrace[1]:A}" \
    -- /dev/fd/3  3<<<$output \
       /dev/fd/4  4<<<$expect \
    || { errdiff=$?
      # ENH: only print when VERBOSE=1 OR GENERATE=1
      ((colorize)) && print -nP '%F{10}'
      GenerateTestcase $1
      ((colorize)) && print -nP '%f'
      print "\n---"
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

function PrintSummary {
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

function PrettyTerminal { declare -A vars
  vars=( [$d_btrx]=':' [$HOME]='~' )
  sed -u "$(for k v in ${(kv)vars}; do print "s|$k\\\\b|$v|g"; done)"
}


export TESTSUITE=1
[[ -t 1 ]] && exec > >(PrettyTerminal)
GROUP ${1:-${ZSH_ARGZERO:A}}
trap PrintSummary EXIT
