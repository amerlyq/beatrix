#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: view operational logs
#%

#%ALIAS
.PHONY: e log rmlog
e: log
log: log-latest-edit
rmlog: log-latest-remove


#%ALIAS
.PHONY: p
p: EDITOR := $(or $(PAGER),$(LESS),less -r)
p: log


# HACK: skip current log and open previous one
&lastlog = $(shell log-latest '' 2)


.PHONY: log-latest-edit
log-latest-edit:
	>/dev/tty $(EDITOR) '$(&lastlog)'



# MAYBE: $(if $(INTERACTIVE),,--interactive)
.PHONY: log-latest-remove
log-latest-remove:
	rm --interactive --verbose '$(&lastlog)'
