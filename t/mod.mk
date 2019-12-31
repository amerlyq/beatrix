#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: testsuite of beatrix itself (reused by main projects)
#%
$(call &AssertVars,&here bdir)


.PHONY: t tc ts tS
#%ALIAS: [test]
t: test                     # run testapp with unit tests :: RQ(cmake configure): btst=ON
tc: ctest                   # run testsuite registered in CTest
ts: test-self               # execute build system glue self-testing suite
tS: test-self-gen           # generate testsuite for space-separate targets in VAR self.args='...'



## BAD: always rebuilds whole project and never runs tests at all
##   $ ctest --build-and-test '$(d_pj)' '$(bdir)' --build-generator "Unix Makefiles" --build-nocmake --build-noclean --output-on-failure --build-project runtests
.PHONY: ctest
ctest:
	+$(CMAKE) --build '$(bdir)' --target testapp -- ARGS="--output-on-failure"


# USAGE: create new testsuite for cmdline
#  A) create new testfile, place "exec </dev/null" on top, add all "CHECK cmd...",
#    then run testsuite and append suggested "CHECK" blocks for broken tests
#  B) ALT: pick all necessary targets and directly redirect generated output to file
.PHONY: test-self-gen
test-self-gen: self.mod := -
test-self-gen: test-self


.PHONY: test-self
test-self:

ifneq (,$(wildcard $(&here)/testsuite))
test-self: $(&here)/testsuite
	'$<' $(self.mod) $(self.args)
endif
