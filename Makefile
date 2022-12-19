NIX := nix
STATIX := $(NIX) run nixpkgs\#statix --
NODE2NIX := $(NIX) run nixpkgs\#node2nix --

.PHONY: test
test:
	$(STATIX) check
	env NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 NIXPKGS_ALLOW_BROKEN=1 $(NIX) flake check --impure

.PHONY: update
update:
	cd ./npm && \
	rm -f ./*.nix && \
	$(NODE2NIX) --input ./deps.json

.PHONY: upgrade
upgrade: update
	@# alias helper for 'update'
	@true
