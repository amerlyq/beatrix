#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Creates linkable .rodata *.o resources and its interface library wrapper

* auto null-terminated TEXT resource and unchanged BINARY
* has three actual C symbols :: _binary_*_{start,end,size}
* provides convenient *.i header file to include LOCAL or GLOBAL resource
* creates interface library to use with target_link_libraries()


INFO
----

REF:(inspired by): https://beesbuzz.biz/code/4399-Embedding-binary-resources-with-CMake-and-C-11

THINK:DEV? "add_resources_merge(myrc ...)" to create single named *.o and *.i from multiple resources


USAGE
-----

Single resource with custom name::

    make_resource(name /path/to/resource [LOCAL|GLOBAL] [TEXT|BINARY])


Multiple resources identified by file basename::

    make_resource_from_each(
      [LOCAL|GLOBAL] [TEXT|BINARY]
        /path/to/resource1 ...
      [LOCAL|GLOBAL] [TEXT|BINARY]
        /path/to/resourceN ...
      ...
    )


CMake::

    include(fn-resources)
    make_resource(myrc data/note.txt)
    make_resource_from_each(data/note.txt ...)
    target_link_libraries(${PROJECT_NAME} PRIVATE rc::note_txt)


CXX::

    #include <note_txt.i>
    auto const some = std::string(_binary_note_txt_start, _binary_note_txt_size);


CXX17+::

    #include <note_txt.i>
    auto some = note_txt;  // <- constexpr std::string_view

#]=======================================================================]


set(BEATRIX_RESOURCES_DIR "rc"
  CACHE PATH "Subdirectory to contain all compiled resources (project-global or component-local)")

set(BEATRIX_RESOURCES_INTERFACE_PREFIX "rc"
  CACHE STRING "Prefix of all interface libraries (DFL: 'rc'::*  to refer in CMake)")

set(BEATRIX_RESOURCES_SYMBOL_PREFIX ""
  CACHE STRING "Additional prefix of all global symbols (e.g. use '_rc_*' to prevent namespace clashing)")
if(BEATRIX_RESOURCES_SYMBOL_PREFIX MATCHES "[^a-zA-Z0-9_]")
  message(FATAL_ERROR "Unsupported prefix '${nm}', use only allowed in 'C/C++' identifiers")
endif()


find_program(mkrc_exe NAMES elf-resource-make)


function(make_resource_from_each)
  set(scope LOCAL)
  set(datatype TEXT)

  # INFO: can alternate LOCAL/GLOBAL and TEXT/BINARY inside arguments list
  foreach(src IN LISTS ARGN)
    if(src STREQUAL LOCAL OR src STREQUAL GLOBAL)
      set(scope ${src})
    elseif(src STREQUAL TEXT OR src STREQUAL BINARY)
      set(datatype ${src})
    else()
      get_filename_component(nm ${src} NAME)
      string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" nm ${nm})
      make_resource(${nm} ${src} ${scope} ${datatype})
    endif()
  endforeach()
endfunction()


function(make_resource nm src)
  if(NOT nm OR nm MATCHES "[^a-zA-Z0-9_]")
    message(FATAL_ERROR "Unsupported resource name '${nm}', use only allowed in 'C' identifiers")
  endif()
  get_filename_component(src ${src} ABSOLUTE)

  set(tgt ${BEATRIX_RESOURCES_INTERFACE_PREFIX}::${nm})
  set(scope LOCAL)
  set(datatype TEXT)

  foreach(kw IN LISTS ARGN)
    if(kw STREQUAL LOCAL OR kw STREQUAL GLOBAL)
      set(scope ${kw})
    elseif(kw STREQUAL TEXT OR kw STREQUAL BINARY)
      set(datatype ${kw})
    else()
      message(FATAL_ERROR "Unsupported keyword '${kw}'")
    endif()
  endforeach()

  # MAYBE? place *.i into subdir to be able to group includes like "#include <rc/some.i>"
  # WARN: all resources symbols are global for ELF -- impossible to have same name for different resources
  #  => local resources like "USAGE_txt" are supported when they go into different ELFs
  #  => cmake generates ERR when trying to create another resource with same name (both global or local in same scope)
  #  => linker generates ERR when linking two ELFs with name collision in local resources
  #    CHECK! maybe instead of conflicting second .o will be simply ignored
  if(scope STREQUAL GLOBAL)
    set(dir ${CMAKE_BINARY_DIR}/${BEATRIX_RESOURCES_DIR})
    add_library(${tgt} INTERFACE IMPORTED GLOBAL)
  elseif(scope STREQUAL LOCAL)
    set(dir ${CMAKE_CURRENT_BINARY_DIR}/${BEATRIX_RESOURCES_DIR})
    add_library(${tgt} INTERFACE IMPORTED)
  endif()

  # NOTE: create dst directory to be able to link it now
  set(rc ${dir}/${nm})
  get_filename_component(rc_dir ${rc} DIRECTORY)
  file(MAKE_DIRECTORY ${rc_dir})
  # ALT:(cmake<=3.7): set_property(TARGET ${tgt} PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${dir})
  target_include_directories(${tgt} INTERFACE ${dir})

  set(mkrc_cmd ${mkrc_exe})
  if(BEATRIX_RESOURCES_SYMBOL_PREFIX)
    list(APPEND mkrc_cmd --prefix ${BEATRIX_RESOURCES_SYMBOL_PREFIX})
  endif()
  if(datatype STREQUAL TEXT)
    list(APPEND mkrc_cmd --text)
  endif()

  # NOTE: when ${src} file updated -- whole resource will be recompiled automatically
  add_custom_command(OUTPUT ${rc}.o ${rc}.i
    COMMAND
      ${CMAKE_COMMAND} -E env LINKER=${CMAKE_LINKER} OBJCOPY=${CMAKE_OBJCOPY}
        ${mkrc_cmd} -- ${nm} ${src} ${rc}
    DEPENDS ${src}
    WORKING_DIRECTORY ${dir}
    COMMENT "Generating embedded resource '${nm}'"
    VERBATIM
  )

  # ALT:(cmake<=3.7): set_property(TARGET ${tgt} PROPERTY INTERFACE_SOURCES ${rc}.o ${rc}.i)
  target_sources(${tgt} INTERFACE ${rc}.o ${rc}.i)

  # CHECK: is it needed MAYBE: generated sources auto-added as deps in target_sources()
  add_dependencies(${tgt} ${rc}.o ${rc}.i)

endfunction()
