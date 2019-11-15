#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: view operational logs
#%

.PHONY: e p log logx rmlog
#%ALIAS [logging]
e: log
p: log-latest-view
log: log-latest-edit
logx rmlog: log-latest-remove



# HACK: skip current log and open previous one
&lastlog = $(shell log-latest '' 2)


.PHONY: log-latest-view
log-latest-view: EDITOR := $(or $(PAGER),$(LESS),less -r)
log-latest-view: log-latest-edit



.PHONY: log-latest-edit
log-latest-edit:
	>/dev/tty $(EDITOR) '$(&lastlog)'



# MAYBE: $(if $(INTERACTIVE),,--interactive)
.PHONY: log-latest-remove
log-latest-remove:
	rm --interactive --verbose '$(&lastlog)'
