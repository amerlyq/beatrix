#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: show components dependency graph in graphviz
#%
$(call &AssertVars,bdir &here)

.gview := $(&here)view-auto


.PHONY: gvg gv
#%ALIAS: [graphviz]         #[components dependency graph]
gvg: graphviz-gen           # generate cmake projects dependency graph
gv: graphviz-main           # view main deps file by graphviz



# MAYBE:BET:RENAME: use more generic target "analyze-deps[-view]"
# TODO: additional analysis from "ninja -t list" -> {browse,deps,graph,...}

.PHONY: graphviz-gen
graphviz-gen: _pfx = $(bdir)/_gv/g
graphviz-gen: cmake.args += --graphviz='$(_pfx)'
graphviz-gen: config-refresh
	find '$(_pfx)' -type f -name 'g*' -execdir mv '{}' '{}.gv' \;


graphviz-main: _pfx = $(bdir)/_gv/g
graphviz-main:
	'$(.gview)' '$(_pfx).gv'
