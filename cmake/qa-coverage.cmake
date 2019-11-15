#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Coverage report generator

USAGE
-----

Run all necessary executables (main/tests), then manually refresh stampfile by
the custom command "make coverage-invalidate"

REF
---

* https://stackoverflow.com/questions/13116488/detailed-guide-on-using-gcov-with-cmake-cdash
* https://github.com/bilke/cmake-modules/blob/master/CodeCoverage.cmake

#]=======================================================================]
include_guard(DIRECTORY)


#%ALIAS(opt)
option(USE_COVERAGE "Enable producing coverage reports" ON)
if(NOT USE_COVERAGE)
  return()
endif()

option(BEATRIX_COVERAGE_ENABLE "Enable producing coverage reports" ${USE_COVERAGE})


set(BEATRIX_COVERAGE_DIR ${CMAKE_BINARY_DIR}/_coverage
  CACHE PATH "Directory to store coverage report")

set(BEATRIX_COVERAGE_FILTER
  "${CMAKE_PREFIX_PATH}/*"
  "*/boost/*"
  "*/gen/*"
  "*/gmock/*"
  "*/gtest/*"
  "*/test/*"
  "/usr/*"
)

set(_stampfile ${BEATRIX_COVERAGE_DIR}/--gcda-generated--)
set(_covinfo ${BEATRIX_COVERAGE_DIR}/coverage.info)
set(_htmlreport ${BEATRIX_COVERAGE_DIR}/report/index.html)


find_program(lcov_exe NAMES lcov)
find_program(genhtml_exe NAMES genhtml)
find_program(xdgopen_exe NAMES xdg-open)


if(BEATRIX_COVERAGE_ENABLE)
  add_compile_options(--coverage)
  add_link_options(--coverage)
endif()



add_custom_target(coverage-invalidate DEPENDS ${_stampfile})
add_custom_command(
  OUTPUT ${_stampfile}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${BEATRIX_COVERAGE_DIR}
  # COMMAND ${coverage_TARGET} || true
  COMMAND ${CMAKE_COMMAND} -E touch ${_stampfile}
  # DEPENDS ${coverage_TARGET}
  VERBATIM
)


add_custom_target(coverage-info DEPENDS ${_covinfo})
add_custom_command(
  OUTPUT ${_covinfo}
  COMMAND ${lcov_exe} --quiet --capture --directory ${CMAKE_BINARY_DIR} --output-file ${_covinfo}
  COMMAND ${lcov_exe} --quiet --remove ${_covinfo} --output-file ${_covinfo} -- ${BEATRIX_COVERAGE_FILTER}
  DEPENDS ${_stampfile}
  VERBATIM
)


add_custom_target(coverage-html DEPENDS ${_htmlreport})
add_custom_command(
  OUTPUT ${_htmlreport}
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${BEATRIX_COVERAGE_DIR}/report/
  COMMAND ${genhtml_exe} ${_covinfo} --output-directory ${BEATRIX_COVERAGE_DIR}/report
  DEPENDS ${_covinfo}
  VERBATIM
)


add_custom_target(coverage-open
  COMMAND ${launcher_exe} ${xdgopen_exe} ${_htmlreport}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  USES_TERMINAL
  VERBATIM
)
