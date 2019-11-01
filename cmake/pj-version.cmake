#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Retrieve semantic version tag of requested repo in format "0.0.0[-rN][-g0347861][-dirty]"

DEV: explicit verbatim versioning:

* Use dedicated file VERSION per each project/module root -- containing full tag (like above)
* Populate both CMake "PROJECT_VERSION" and PKGBUILD "pkgver()" by reading that file
* Fallback to git version if file is nonexistent OR git version was forcefully overridden
* FAIL:(git): can't derive values when using *.tar.gz sources without .git folder
* FAIL:(git): provides common version of whole repo instead of per-component
* BAD:(version): must git tag new commits manually by same VERSION (duplicated info)
* NEED:(git-tag-update hook): tag whole repo commit if main project ./version > last tag
  (where "./" == in whichever folder beatrix tools run)
* BUT: monorepos may have tag version as whole different from each individual product
* MAYBE:IDEA: create named tags to coexist :: "beatrix-0.1.0" and "myproject-0.0.2"


ALT::

    file(GENERATE OUTPUT ... CONTENT "$<CONFIG>")
    configure_file(.../VERSION ${PROJECT_SOURCE_DIR}/VERSION @ONLY)
    install(EXPORT...)


USAGE
-----

git_describe(${CMAKE_CURRENT_SOURCE_DIR} PROJECT_VERSION)

#]=======================================================================]


find_program(git_exe NAMES git)


#%USAGE: catch_or_die_at(output workdir cmd [args])
function(catch_or_die_at var dir)
  # ERROR! without full re-configure will embed old version into source files when developing
  execute_process(
    COMMAND ${ARGN}
    WORKING_DIRECTORY ${dir}
    OUTPUT_VARIABLE _out
    RESULT_VARIABLE _rc
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if(NOT _rc STREQUAL 0)
    message(FATAL_ERROR "Err(${_rc}): ${ARGN}")
  endif()
  set(${var} ${_out} PARENT_SCOPE)
endfunction()


function(git_describe repo var)
  # NOTE: usable tags must match /v?\d+\.\d+\.\d+/ -- otherwise use fallback
  catch_or_die_at(_tag ${repo} ${git_exe} describe --always --dirty --tags --match "*.*.*")
  string(REGEX MATCH "^[0-9]+\\.[0-9]+(\\.[0-9]+)?([.-][0-9]+)?" _ver ${_tag})
  if(_ver)
    string(REPLACE "-" "." _ver ${_ver})
  else()
    set(_ver "0.0.0")
    set(_tag "${_ver}-${_tag}")
  endif()

  # NOTE: append macro for each remaining arg (source files)
  # THINK:MAYBE: cache version variables to execute GIT only once when adding macro to different source files
  foreach(src IN LISTS ARGN)
    set_property(SOURCE ${src} APPEND
      PROPERTY COMPILE_DEFINITIONS "${var}=${_tag}")
  endforeach()

  # DEBUG:
  # message(FATAL_ERROR "var=${_ver} | tag=${_tag}")

  set(${var}     "${_ver}" PARENT_SCOPE)
  set(${var}_TAG "${_tag}" PARENT_SCOPE)
endfunction()
