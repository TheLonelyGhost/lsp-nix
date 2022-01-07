{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.dot-language-server.override {
  meta = {
    description = "A language Server for the DOT language/Graphviz.";
    homepage = "https://github.com/nikeee/dot-language-server";
  };
}
