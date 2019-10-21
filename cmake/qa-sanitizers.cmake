#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

REF
---

:/aeternum/languages/cxx/clang.nou

#]=======================================================================]

set(USE_SANITIZERS "" CACHE STRING "Code santitizers (only tested on Clang)")
set_property(CACHE USE_SANITIZERS PROPERTY STRINGS ";address;memory;thread;UB")


#%BAD! some sanitizers conflict with each other => build each separately
set(qa_saint)
if(NOT USE_SANITIZERS)
  return()

elseif(USE_SANITIZERS STREQUAL "address")
  list(APPEND qa_saint -fsanitize=address -fsanitize-address-use-after-scope)

elseif(USE_SANITIZERS STREQUAL "memory")
  list(APPEND qa_saint -fsanitize=memory -fsanitize-memory-track-origins=2)
  # THINK: -fno-optimize-sibling-calls

elseif(USE_SANITIZERS STREQUAL "thread")
  list(APPEND qa_saint -fsanitize=thread)

elseif(USE_SANITIZERS STREQUAL "UB")
  list(APPEND qa_saint -fsanitize=undefined)

else()
  message(FATAL_ERROR "Unknown sanitizer=${USE_SANITIZERS}")

endif()
message("[+] USE_SANITIZERS=${USE_SANITIZERS}\n")


## NOTE: better C backtrace on x86_64 BAD: no useful effect on ARM
list(APPEND qa_saint -fno-omit-frame-pointer)


# BUG:(undefined reference): it seems these options aren't added to linker
# add_compile_options(${qa_saint})

string(REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS};${qa_saint}")
string(REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS};${qa_saint}")
# TRY:DEV:(CMAKE_BUILD_TYPE=Sanitized): set(CMAKE_CXX_FLAGS_SANITIZED -g -O1)
