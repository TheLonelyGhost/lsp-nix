{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.vscode-langservers-extracted.override {
  meta = {
    description = "HTML, CSS, and JSON language servers extracted from Visual Studio Code.";
    homepage = "https://github.com/hrsh7th/vscode-langservers-extracted";
    inherit (nodejs.meta) platforms;
  };
}
