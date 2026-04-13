test: $(addsuffix .runtest, $(shell find . -name test.nix))
%.nix.runtest: %.nix
	nix eval -f $< | tee /dev/tty | grep -q '\[ \]'
