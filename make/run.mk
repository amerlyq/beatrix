#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: run executables of built project
#%
$(call &AssertVars,brun CMAKE)


.PHONY: r
#%ALIAS: [run]              #[REPL flow]
r: run                      # run chosen executable of current project: brun=Main



# WARN! must always launch executable targets exclusively through CMake
#   <= to generate timestamps, etc. and run dependent actions (e.g. coverage)
# NOTE: implicit dependency on "$(bdir)/--configure--" prevents error "build dir does not exists"
# ALT: install then run :: $(abspath $(bdir))/_install/bin/main
#   RQ: to run tests inside installed dir -- you still must know defaults
#   CASE: not all tools are possible to run as custom commands from inside CMake
.PHONY: run
run: tgt = run.$(or $(X),$(brun))
run: export ARGS = $(run.args)
run: export WRAP = $(run.wrap)
run: build



.PHONY: run-gpu
run-gpu: CMAKE := optirun --bridge primus -- $(CMAKE)
run-gpu: run



## FAIL: can use "sudo" only on fully built project -- otherwise some artifacts will be rebuilt under "root" user
# ALT: $ sudo chrt --fifo --all-tasks --pid 15 $(pidof app)
# .PHONY: run-gpu-prio
# run-gpu-prio: CMAKE := sudo nice -n -4 taskset --cpu-list 0-8:2 $(CMAKE)
# run-gpu-prio: run
