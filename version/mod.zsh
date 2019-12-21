#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: derive version from Git / CMake / "version" file
#%

function _version {
  local path+=${${(%):-%x}:h}
  from-git $d_pj $@ && return
  >&2 echo "Must have at least one symver tag for versioning to work ( e.g. add tag by 'git tag 0.0.1' )"
  exit 1
}

function version { _version only; }

function version-full { _version; }

function VERSION { _version > VERSION; }
