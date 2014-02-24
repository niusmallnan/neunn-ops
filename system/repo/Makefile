PREFIX ?= /usr/local
BINS = $(wildcard repo-*)


install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@echo "... installing bins to $(DESTDIR)$(PREFIX)/bin"
	@$(foreach BIN, $(BINS), \
		echo "... installing `basename $(BIN)`"; \
		cp -f $(BIN) $(DESTDIR)$(PREFIX)/bin; \
	)

uninstall:
	@$(foreach BIN, $(BINS), \
		echo "... uninstalling $(DESTDIR)$(PREFIX)/bin"; \
		rm -f $(DESTDIR)$(PREFIX)/bin; \
	)


