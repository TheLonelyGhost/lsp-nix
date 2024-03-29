{
  description = "Custom tools for nix-based workstations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11-small";
    flake-utils.url = "flake:flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    overlays.url = "github:thelonelyghost/blank-overlay-nix";
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, overlays }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            overlays.overlays.default
          ];
        };

        # Override here in case an older nodejs version is needed for node2nix
        #
        # @see https://github.com/nix-community/npmlock2nix/issues/45
        inherit (pkgs) nodejs;

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.bashInteractive
            pkgs.gnumake
            pkgs.nodePackages.node2nix
            pkgs.nix-prefetch-git
            pkgs.statix
          ];

          NODE2NIX = "${pkgs.nodePackages.node2nix}/bin/node2nix";
          STATIX = "${pkgs.statix}/bin/statix";

          buildInputs = [
          ];
        };

        packages = {
          # Managed in-repo
          dot-language-server = import ./packages/dot-language-server.nix { inherit pkgs nodejs; };
          standard = import ./packages/standard.nix { inherit pkgs nodejs; };
          stylelint-lsp = import ./packages/stylelint-lsp.nix { inherit pkgs nodejs; };
          ts-standard = import ./packages/ts-standard.nix { inherit pkgs nodejs; };
          typescript-language-server = import ./packages/typescript-language-server.nix { inherit pkgs nodejs; };
          vim-language-server = import ./packages/vim-language-server.nix { inherit pkgs nodejs; };
          vscode-langservers-extracted = import ./packages/vscode-langservers-extracted.nix { inherit pkgs nodejs; };

          # Shim so we can safely version what's stable from nixpkgs
          inherit (pkgs.python3Packages) yamllint flake8-import-order flake8 isort;
          inherit (pkgs.nodePackages) stylelint jsonlint htmlhint eslint;

          # linters and formatters
          inherit (pkgs) statix rubocop hadolint yapf vale shellcheck golangci-lint ruff;
          vint = pkgs.vim-vint;

          # language servers
          inherit (pkgs.nodePackages) bash-language-server pyright yaml-language-server;
          inherit (pkgs) solargraph scry gopls;
          nim-language-server = pkgs.nimlsp;
          diagnostic-language-server = pkgs.nodePackages.diagnostic-languageserver;
          dockerfile-language-server = pkgs.nodePackages.dockerfile-language-server-nodejs;
          nix-language-server = pkgs.rnix-lsp;
          rust-analyzer = pkgs.rust-analyzer-unwrapped;
          terraform-language-server = pkgs.terraform-ls;
        };
      }
    ));
}
