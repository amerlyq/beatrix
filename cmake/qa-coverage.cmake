#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Coverage report generator

ARCH
----

Coverage report is tightly related to accumulated runs of single separate executable.
Therefore we must provide something akin "add_coverage_targets(...)" to mark what we are interested in.
BUT: it will be possible only if we able to propagate "--coverage" flags downwards to all dependencies.
Of course, we could walk deps list recursively to add such flags post-factum, but it's a "filthiest thing".
ALT:BET? make separate build type for "--coverage" only -- and enable it globally.
FAIL: we still can't use per-executable report -- because we are able to scan only whole projects for .gcda files.
Therefore we must pick *single* executable to represent coverage of whole project.

USAGE
-----

Enable "--coverage" globally, then register executables to generate separate coverage reports:

pj/CMakeLists.txt::

    include(qa-coverage)

pj/testapp/CMakeLists.txt::

    add_executable(${PROJECT_NAME} ...)
    add_coverage_report_for(${PROJECT_NAME})


REF
---

* https://stackoverflow.com/questions/13116488/detailed-guide-on-using-gcov-with-cmake-cdash
* https://github.com/bilke/cmake-modules/blob/master/CodeCoverage.cmake

#]=======================================================================]
include_guard(DIRECTORY)


set(USE_COVERAGE "" CACHE STRING "Target name to run for coverage report")
# option(BEATRIX_COVERAGE_ENABLE "Enable producing coverage reports" ${USE_COVERAGE})

if(NOT USE_COVERAGE)
  return()
endif()


set(BEATRIX_COVERAGE_DIR ${CMAKE_CURRENT_BINARY_DIR}/_coverage
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


# if(BEATRIX_COVERAGE_ENABLE)
  add_compile_options(--coverage)
  add_link_options(--coverage)
# endif()


# MAYBE: move into aux-launcher and define for each exe both "run." and "once."
add_custom_command(OUTPUT ${USE_COVERAGE}.lastrun
  COMMAND ${launcher_exe} $<TARGET_FILE:${USE_COVERAGE}> ${ARGN}
  COMMAND ${CMAKE_COMMAND} -E touch ${USE_COVERAGE}.lastrun
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS $<TARGET_FILE:${USE_COVERAGE}>
  USES_TERMINAL
  VERBATIM
)


find_program(gcovr_exe NAMES gcovr)
# HACK: use non-existing target ${_gcovr_virtual}="/--gcovr--" instead
#   <= to be able to APPEND deps to command and still re-run target each time
set(_gcovrsum ${BEATRIX_COVERAGE_DIR}/gcovr-summary.txt)
add_custom_command(OUTPUT ${_gcovrsum}
  COMMAND ${gcovr_exe} --print-summary --output=${_gcovrsum}
    --root=${CMAKE_CURRENT_SOURCE_DIR} -- ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS ${USE_COVERAGE}.lastrun
  USES_TERMINAL
  VERBATIM
)

add_custom_target(coverage-summary
  COMMAND cat -- ${_gcovrsum}
  DEPENDS ${_gcovrsum}
)


find_program(lcov_exe NAMES lcov)
set(_covinfo ${BEATRIX_COVERAGE_DIR}/coverage.info)
add_custom_target(coverage-info DEPENDS ${_covinfo})
add_custom_command(OUTPUT ${_covinfo}
  COMMAND ${lcov_exe} --quiet --capture --directory ${CMAKE_CURRENT_BINARY_DIR} --output-file ${_covinfo}.tmp
  COMMAND ${lcov_exe} --quiet --remove ${_covinfo}.tmp --output-file ${_covinfo}.tmp -- ${BEATRIX_COVERAGE_FILTER}
  COMMAND ${CMAKE_COMMAND} -E rename ${_covinfo}.tmp ${_covinfo}
  VERBATIM
)


find_program(genhtml_exe NAMES genhtml)
set(_htmlreport ${BEATRIX_COVERAGE_DIR}/report/index.html)
add_custom_target(coverage-html DEPENDS ${_htmlreport})
add_custom_command(OUTPUT ${_htmlreport}
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${BEATRIX_COVERAGE_DIR}/report/
  COMMAND ${genhtml_exe} ${_covinfo} --output-directory ${BEATRIX_COVERAGE_DIR}/report
  DEPENDS ${_covinfo}
  VERBATIM
)


find_program(xdgopen_exe NAMES xdg-open)
add_custom_target(coverage-open
  COMMAND ${launcher_exe} ${xdgopen_exe} ${_htmlreport}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  USES_TERMINAL
  VERBATIM
)


# TODO: move intel below to ./aeternum docs on custom_commands/etc
#   i.e. "FAQ: what ideas does not work at all"

# WARN: must be called in the same directory, where you used "include(qa-coverage)"
function(mark_for_coverage_report)
  foreach(tgt IN LISTS ARGN)
    # BAD:USAGE: must only "include(qa-coverage)" inside the directory of the SINGLE target itself
    #   FAIL: re-runs each time because dependency on "add_custom_target(BYPRODUCTS)" is actually a target one (.PHONY)
    add_custom_command(OUTPUT ${_covinfo} DEPENDS ${tgt}.lastrun APPEND)
    # add_custom_command(OUTPUT ${_gcovr_virtual} DEPENDS ${tgt}.lastrun APPEND)

    # BAD:ARCH: dependency on "add_custom_target" always re-runs target -- must use intermediate no-cmd target
    #   FAIL: info/html also regenerated because we have "intermediate targets" in the chain of deps
    #   BAD: internal target shown in IDE
    #   add_custom_command(OUTPUT ${_covinfo} DEPENDS lastrun.${tgt} APPEND)

    # ALT:FAIL: all dependencies between "add_custom_command" are possible only inside the same dir
    #   REF: https://cmake.org/pipermail/cmake/2009-February/027323.html
    #     * https://stackoverflow.com/questions/29456950/global-custom-target-in-cmake
    #     * http://cmake.3232098.n2.nabble.com/BUG-add-custom-command-TARGET-can-t-see-in-scope-target-td7591262.html
    #   set_source_files_properties($<TARGET_FILE:${tgt}>.lastrun PROPERTIES GENERATED TRUE)
  endforeach()
endfunction()
