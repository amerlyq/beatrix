#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: wrap app by RR for runtime snapshoting and replaying
#%NEED: $ sudo sysctl kernel.perf_event_paranoid=1
#%  <= https://stackoverflow.com/questions/51911368/what-restriction-is-perf-event-paranoid-1-actually-putting-on-x86-perf
#%
$(call &AssertVars,LOGNAME)

# TODO: source GDB frontend (e.g. peda/etc) into RR controlled GDB environment

#%ALIAS
.PHONY: rec play
rec: rr-record
play: rr-replay


#%DEPS:|aur/rr|
#%INFO:(RUNNING_UNDER_RR=1): can check in runtime
export TMPDIR ?= /tmp/$(LOGNAME)
# export RR_TMPDIR :=
# export RR_LOG := all
#%DFL:(_RR_TRACE_DIR): $HOME/.local/share/rr
export _RR_TRACE_DIR := $(TMPDIR)/rr



# PERF: slowdown [1.2x..1.4x]
#   ENH:(2x on laptop): |community/cpupower| $ cpupower frequency-set -g performance
# WARN! rr forces your application's threads to execute on a single core
#%DATA: $_RR_TRACE_DIR/application-$n
.PHONY: rr-record
rr-record: export WRAP += rr record
# BAD:(order of deps): must create dir before running
rr-record: $(_RR_TRACE_DIR)/ run



#%SUM: rr automatically spawns a gdb client and connects it to the replay server
#%INFO: restarted replay session will execute exactly the same sequence of instructions
#%  * gdb's reverse-continue, reverse-step, reverse-next, and reverse-finish commands all work under rr
#%WARN! use "rr pack" to copy all exe/lib into image -- otherwise you must keep "myexe" the same
.PHONY: rr-replay
rr-replay:
	rr replay  # some-other-trace-dir | -p PID | -f FORK | -g EVENT
