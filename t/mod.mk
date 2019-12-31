#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: testsuite of beatrix itself (reused by main projects)
#%
$(call &AssertVars,&here bdir)


.PHONY: t tc ts
#%ALIAS: [test]
t: test                     # run testapp with unit tests :: RQ(cmake configure): btst=ON
tc: ctest                   # run testsuite registered in CTest
ts: test-self               # execute build system glue self-testing suite



## BAD: always rebuilds whole project and never runs tests at all
##   $ ctest --build-and-test '$(d_pj)' '$(bdir)' --build-generator "Unix Makefiles" --build-nocmake --build-noclean --output-on-failure --build-project runtests
.PHONY: ctest
ctest:
	+$(CMAKE) --build '$(bdir)' --target testapp -- ARGS="--output-on-failure"



.PHONY: test-self
test-self:

ifneq (,$(wildcard $(&here)/testsuite))
test-self: $(&here)/testsuite
	'$<' $(self.args)
endif
