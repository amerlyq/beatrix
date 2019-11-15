#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Augment each running command with cmdline and additional wrappers from ENV.

#]=======================================================================]

option(BEATRIX_LAUNCHER_ENABLE "Run executable targets with args read from ENV" ON)


if(BEATRIX_LAUNCHER_ENABLE)
  find_program(launcher_exe NAMES run-env-args)
else()
  set(launcher_exe)
endif()


## FAIL!(Ninja): always escaped to "\$\$WRAP" NEED: unescaped env var $$WRAP
##   REF:REQ: https://github.com/ninja-build/ninja/issues/1387
# set(_cmd)
# if(CMAKE_GENERATOR STREQUAL "Unix Makefiles")
#   set(_cmd "$(WRAP)" $<TARGET_FILE:${PROJECT_NAME}> "$(ARGS)")
# elseif(CMAKE_GENERATOR STREQUAL "Ninja")
#   set(_cmd $$WRAP $<TARGET_FILE:${PROJECT_NAME}> $$ARGS)
# else()
#   message(FATAL_ERROR "Err: must decide on wrapper syntax for generator='${CMAKE_GENERATOR}'")
# endif()


# THINK:RENAME: add_custom_launcher(...)
function(add_runnable_targets)
  foreach(tgt IN LISTS ARGN)
    add_runnable_alias(${tgt})
  endforeach()
endfunction()


function(add_runnable_alias tgt)
  get_target_property(type ${tgt} TYPE)
  if(NOT type STREQUAL EXECUTABLE)
    # BAD: must create workaround for LibExec pattern to also work
    message(FATAL_ERROR "add_runnable_*(${tgt}) is only available for executables")
  endif()
  get_target_property(srcs ${tgt} SOURCES)
  add_custom_target(run.${tgt}
    COMMENT "run.${tgt} ${ARGN}"
    COMMAND ${launcher_exe} $<TARGET_FILE:${tgt}> ${ARGN}
    COMMAND ${CMAKE_COMMAND} -E touch ${tgt}.lastrun
    # DISABLED: provide separate "add_custom_command" for "run_once."
    # BYPRODUCTS ${tgt}.lastrun
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    SOURCES ${srcs}
    USES_TERMINAL
    VERBATIM
  )
  add_dependencies(run.${tgt} ${tgt})
  # HACK: crappy workaround to allow global dependencies on artifacts produced
  #   by target in runtime e.g. coverage-report => .gcda
  # FAIL: results in regeneration of whole next chain of "add_custom_command" deps
  # add_custom_target(lastrun.${tgt} DEPENDS ${tgt}.lastrun)
endfunction()
