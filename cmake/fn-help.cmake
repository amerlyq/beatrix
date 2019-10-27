#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Extract help ("//%" comments) from sources and embed into ELF

#]=======================================================================]

find_program(elfrc_help NAMES elf-resource-help)

include(fn-resources)


function(target_add_embedded_help tgt)
  get_target_property(srcs ${tgt} SOURCES)
  get_target_property(dir ${tgt} SOURCE_DIR)
  set(d_tmpl ${CMAKE_CURRENT_BINARY_DIR})
  set(helptmpl ${d_tmpl}/AUTOHELP)

  # FAIL: configure_file() runs immediately on CMake/configure step
  #   -- impossible to chain after add_custom_command() for ${helptmpl}
  #   NEED: different documentation pipeline to substitute variables inside extracted text
  #   https://cmake.org/pipermail/cmake/2012-May/050221.html
  add_custom_command(OUTPUT ${helptmpl}
    COMMAND ${elfrc_help} ${helptmpl} ${srcs}
    DEPENDS ${elfrc_help} ${srcs}
    WORKING_DIRECTORY ${dir}
    COMMENT "Generating embedded autohelp '${nm}'"
    VERBATIM
  )

  get_filename_component(nm ${helptmpl} NAME)
  string(REGEX REPLACE ".in" "" nm ${nm})
  string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" var ${nm})
  make_resource(${var} ${helptmpl} LOCAL TEXT)
  target_link_libraries(${tgt} PRIVATE rc::${var})

  # ALG: External static help files (can contain CMake vars)
  foreach(tmpl IN LISTS ARGN)
    get_filename_component(nm ${tmpl} NAME)
    string(REGEX REPLACE ".in" "" nm ${nm})
    configure_file(${tmpl} ${d_tmpl}/${nm})
    string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" var ${nm})
    make_resource(${var} ${d_tmpl}/${nm} LOCAL TEXT)
    target_link_libraries(${tgt} PRIVATE rc::${var})
  endforeach()
endfunction()
