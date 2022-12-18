{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.stylelint-lsp.override {
  meta = {
    description = "An implementation of the Language Server Protocol for stylelint";
    homepage = "https://github.com/bmatcuk/stylelint-lsp";
    inherit (nodejs.meta) platforms;
  };
}
