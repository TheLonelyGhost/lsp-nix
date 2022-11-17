{
  description = "Custom tools for nix-based workstations";
  inputs.nixpkgs.url = "flake:nixpkgs";
  inputs.flake-utils.url = "flake:flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.overlays.url = "github:thelonelyghost/blank-overlay-nix";

  outputs = { self, nixpkgs, flake-utils, flake-compat, overlays }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [overlays.overlays.default];
        };

        # 14.x is the latest that node2nix (and others) can support due to some changes in how
        # the package-lock.json (and other resolved dependencies') versions are parsed. Update
        # this version once we can because this is super old by now.
        #
        # @see https://github.com/nix-community/npmlock2nix/issues/45
        nodejs = pkgs.nodejs-14_x;

      in
        {
          devShell = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.bashInteractive
              pkgs.gnumake
              pkgs.nodePackages.node2nix
            ];
            buildInputs = [];
          };

          packages = {
            # Managed in-repo
            dot-language-server = import ./packages/dot-language-server.nix { inherit pkgs nodejs; };
            stylelint-lsp = import ./packages/stylelint-lsp.nix { inherit pkgs nodejs; };
            typescript-language-server = import ./packages/typescript-language-server.nix { inherit pkgs nodejs; };
            vim-language-server = import ./packages/vim-language-server.nix { inherit pkgs nodejs; };
            vscode-langservers-extracted = import ./packages/vscode-langservers-extracted.nix { inherit pkgs nodejs; };

            # Shim so we can safely version what's stable from nixpkgs
            eslint = pkgs.nodePackages.eslint;
            htmlhint = pkgs.nodePackages.htmlhint;
            jsonlint = pkgs.nodePackages.jsonlint;
            stylelint = pkgs.nodePackages.stylelint;
            isort = pkgs.python3Packages.isort;
            flake8 = pkgs.python3Packages.flake8;
            flake8-import-order = pkgs.python3Packages.flake8-import-order;
            yamllint = pkgs.python3Packages.yamllint;
            shellcheck = pkgs.shellcheck;
            vint = pkgs.vim-vint;

            gopls = pkgs.gopls;
            scry = pkgs.scry;
            nim-language-server = pkgs.nimlsp;
            bash-language-server = pkgs.nodePackages.bash-language-server;
            diagnostic-language-server = pkgs.nodePackages.diagnostic-languageserver;
            dockerfile-language-server = pkgs.nodePackages.dockerfile-language-server-nodejs;
            pyright = pkgs.nodePackages.pyright;
            yaml-language-server = pkgs.nodePackages.yaml-language-server;
            nix-language-server = pkgs.rnix-lsp;
            rust-analyzer = pkgs.rust-analyzer-unwrapped;
            solargraph = pkgs.solargraph;
            terraform-language-server = pkgs.terraform-ls;
          };
        }
    );
}
