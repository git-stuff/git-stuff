# Makefile

SHELL := sh -e

LANGUAGES = $(shell cd manpages/po && ls)

SCRIPTS = debian/*.config debian/*.postinst debian/*.postrm \
	  $(shell ls scripts/* | grep -v .pl | grep -v git-hook-notification-bts) # FIXME

all: build

test:
	@echo -n "Checking for syntax errors"

	@for SCRIPT in $(SCRIPTS); \
	do \
		if [ -e $${SCRIPT} ]; \
		then \
			sh -n $${SCRIPT}; \
			echo -n "."; \
		fi; \
	done

	@echo " done."

	@if [ -x "$$(which checkbashisms 2>/dev/null)" ]; \
	then \
		echo -n "Checking for bashisms"; \
		for SCRIPT in $(SCRIPTS); \
		do \
			if [ -e $${SCRIPT} ]; \
			then \
				checkbashisms -f -x $${SCRIPT}; \
				echo -n "."; \
			fi; \
		done; \
		echo " done."; \
	else \
		echo "W: checkbashisms - command not found"; \
		echo "I: checkbashisms can be optained from: "; \
		echo "I:   http://git.debian.org/?p=devscripts/devscripts.git"; \
		echo "I: On Debian systems, checkbashisms can be installed with:"; \
		echo "I:   apt-get install devscripts"; \
	fi

build:
	@echo "Nothing to build."

install:
	# Installing scripts
	mkdir -p $(DESTDIR)/usr/bin
	cp -r scripts/* $(DESTDIR)/usr/bin

	# Installing docs
	mkdir -p $(DESTDIR)/usr/share/doc/git-stuff
	cp -r COPYING docs $(DESTDIR)/usr/share/doc/git-stuff

	# Installing manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE}); \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

uninstall:
	# Uninstalling scripts
	for _SCRIPT in $${SCRIPTS}; \
	do \
		rm -f $(DESTDIR)/usr/bin/$$(basename $${_SCRIPT}); \
	done

	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/bin || true

	# Uninstalling docs
	rm -rf $(DESTDIR)/usr/share/doc/git-stuff
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/doc

	# Uninstalling manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		rm -f $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE} .en.$${SECTION}).$${SECTION}; \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			rm -f $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

	for SECTION in $(ls manpages/en/* | awk -F. '{ print $2 }'); \
	do \
		rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man/man$${SECTION} || true; \
		rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man/*/man$${SECTION} || true; \
	done

	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man || true

	# Removing remaining directories
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share || true
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr || true
	rmdir --ignore-fail-on-non-empty $(DESTDIR) || true

clean:
	@echo "Nothing to clean."

distclean: clean
	@echo "Nothing to distclean."

reinstall: uninstall install
