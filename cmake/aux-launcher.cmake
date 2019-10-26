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


function(run_target_file tgt)
  get_target_property(srcs ${tgt} SOURCES)
  add_custom_target(run.${tgt}
    COMMENT "run.${tgt} ${ARGN}"
    COMMAND ${launcher_exe} $<TARGET_FILE:${tgt}> ${ARGN}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    SOURCES ${srcs}
    USES_TERMINAL
    VERBATIM
  )
  add_dependencies(run.${tgt} ${tgt})
endfunction()
