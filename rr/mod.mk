#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: wrap app by RR for runtime snapshoting and replaying
#%USAGE: $ rr replay --help
#%TUT:USAGE: https://github.com/mozilla/rr/wiki/Usage
#%NEED: $ sudo sysctl kernel.perf_event_paranoid=1
#%  <= https://stackoverflow.com/questions/51911368/what-restriction-is-perf-event-paranoid-1-actually-putting-on-x86-perf
#%
$(call &AssertVars,LOGNAME)

# TODO: source GDB frontend (e.g. peda/etc) into RR controlled GDB environment

# ALT: rr/rg :: rec/play
.PHONY: rr rg rp
#%ALIAS: [debug]    # run and replay process image in GDB
rr: rr-record       # record process history to disk
rg: rr-gdb          # replay process history in GDB
rp: rr-play         # replay process history w/o GDB


#%DEPS:|aur/rr|
#%INFO:(RUNNING_UNDER_RR=1): can check in runtime
# export TMPDIR ?= /tmp/$(LOGNAME)
# export RR_TMPDIR :=
# export RR_LOG := all
#%DFL:(_RR_TRACE_DIR): $HOME/.local/share/rr
# export _RR_TRACE_DIR := $(TMPDIR)/rr
export _RR_TRACE_DIR := $(abspath $(bdir))/_rr



# PERF: slowdown [1.2x..1.4x]
#   ENH:(2x on laptop): |community/cpupower| $ cpupower frequency-set -g performance
# WARN! rr forces your application's threads to execute on a single core
#%DATA: $_RR_TRACE_DIR/application-$n
.PHONY: rr-record
rr-record: run.wrap += rr record
# BAD:(order of deps): must create dir before running
rr-record: $(_RR_TRACE_DIR)/ run



#%SUMMARY: rr automatically spawns a gdb client and connects it to the replay server
#%USAGE: $ rr ... [some-other-trace-dir | -p PID | -f FORK | -g EVENT]
#%INFO: restarted replay session will execute exactly the same sequence of instructions
#%  * gdb's reverse-continue, reverse-step, reverse-next, and reverse-finish commands all work under rr
#%WARN! use "rr pack" to copy all exe/lib into image -- otherwise you must keep "myexe" the same
.PHONY: rr-gdb
rr-gdb:
	rr --mark-stdio replay --debugger-option='-quiet'



#%SUM: autopilot w/o GDB
.PHONY: rr-play
rr-play:
	rr --mark-stdio replay -a
