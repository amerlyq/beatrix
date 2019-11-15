#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: show components dependency graph in graphviz
#%
$(call &AssertVars,bdir)


.PHONY: gv
#%ALIAS: [graphviz]         #[components dependency graph]
gv: graphviz                # generate cmake projects dependency graph



# MAYBE:BET:RENAME: use more generic target "analyze-deps[-view]"
.PHONY: graphviz
graphviz: _pfx = $(bdir)/_gv/g
graphviz: cmake_args += --graphviz='$(_pfx)'
graphviz: config-refresh
	find '$(_pfx)' -type f -name 'g*' -execdir mv '{}' '{}.gv' \;
	graphviz-view '$(_pfx).gv'
