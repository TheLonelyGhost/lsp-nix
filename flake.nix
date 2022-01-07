{
  description = "Custom tools for nix-based workstations";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
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
            dot-language-server = import ./packages/dot-language-server.nix { inherit pkgs nodejs; };
            stylelint-lsp = import ./packages/stylelint-lsp.nix { inherit pkgs nodejs; };
            typescript-language-server = import ./packages/typescript-language-server.nix { inherit pkgs nodejs; };
            vim-language-server = import ./packages/vim-language-server.nix { inherit pkgs nodejs; };
            vscode-langservers-extracted = import ./packages/vscode-langservers-extracted.nix { inherit pkgs nodejs; };
          };
        }
    );
}
