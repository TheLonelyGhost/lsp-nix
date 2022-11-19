
.PHONY: test
test:
	env NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 NIXPKGS_ALLOW_BROKEN=1 nix flake check --impure

.PHONY: update
update:
	cd ./npm && \
		touch ./foo.nix && \
		rm ./*.nix && \
	node2nix --input ./deps.json

.PHONY: upgrade
upgrade: update
	@# alias helper for 'update'
	@true
