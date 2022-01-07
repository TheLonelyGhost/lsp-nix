# Nix Flake: Language Servers

Packages included:

- [`dot-language-server`](https://github.com/nikeee/dot-language-server)
- [`gopls`](https://pkg.go.dev/golang.org/x/tools/gopls)
- [`nim-language-server`](https://github.com/PMunch/nimlsp)
- [`bash-language-server`](https://github.com/bash-lsp/bash-language-server)
- [`diagnostic-language-server`](https://github.com/iamcco/diagnostic-languageserver)
- [`dockerfile-language-server`](https://github.com/rcjsuen/dockerfile-language-server-nodejs)
- [`pyright`](https://github.com/Microsoft/pyright)
- [`nix-language-server`](https://github.com/nix-community/rnix-lsp)
- [`rust-analyzer`](https://rust-analyzer.github.io/)
- [`solargraph`](https://solargraph.org/)
- [`stylelint-language-server`](https://github.com/bmatcuk/stylelint-lsp)
- [`terraform-language-server`](https://github.com/hashicorp/terraform-ls)
- [`typescript-language-server`](https://github.com/typescript-language-server/typescript-language-server)
- [`vim-language-server`](https://github.com/iamcco/vim-language-server)
- [`vscode-langservers-extracted`](https://github.com/hrsh7th/vscode-langservers-extracted)
- [`yaml-language-server`](https://github.com/redhat-developer/yaml-language-server)

CLI tools (to be used with `diagnostic-language-server`):

- [`eslint`](https://eslint.org/)
- [`htmlhint`](https://htmlhint.com/)
- [`jsonlint`](https://jsonlint.com/)
- [`stylelint`](https://stylelint.io/)
- [`isort`](https://pycqa.github.io/isort/)
- [`flake8`](https://flake8.pycqa.org/en/latest/)
- [`flake8-import-order`](https://github.com/PyCQA/flake8-import-order)
- [`yamllint`](http://www.yamllint.com/)
- [`shellcheck`](https://www.shellcheck.net/)
- [`vint`](https://github.com/Vimjas/vint)

## Usage

### With Flakes

Add this repo to your `flake.nix` inputs like:

```nix
{
  # ...
  inputs.lsp-nix.url = "github:thelonelyghost/lsp-nix";
  # ...

  outputs = { self, nixpkgs, flake-utils, lsp-nix, ...}@attrs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      lsp = lsp-nix.packages."${system}";
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.bashInteractive
          lsp.dot-language-server
        ];
      };
    });
}
```

**Updating:** Anytime you want to update what lsp-nix offers, run `nix flake lock --update-input lsp-nix` and rebuild your nix expression acccordingly.

### Without Flakes

If you're not yet using [Nix Flakes][flakes], such as with [`home-manager`][home-manager], here's how you can include it:

1. Install [`niv`][niv] and run `niv init`
2. Run `niv add thelonelyghost/lsp-nix --name lsp-nix`
3. Include the following in your code:

```nix
{ lib, config, ... }:

let
  sources = import ./nix/sources.nix {};
  pkgs = import sources.nixpkgs {};

  lsp = (import (pkgs.fetchFromGitHub { inherit (sources.lsp-nix) owner repo rev sha256; })).outputs.packages."${builtins.currentSystem}";
in
{
  home.packages = [
    lsp.dot-language-server
  ];
}
```

**Updating:** Anytime you want to update what lsp-nix offers, run `niv update lsp-nix` and rebuild your nix expression acccordingly.

[flakes]: https://github.com/NixOS/nix/blob/master/src/nix/flake.md
[home-manager]: https://github.com/nix-community/home-manager
[niv]: https://github.com/nmattia/niv
