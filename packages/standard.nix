{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.standard.override {
  meta = {
    description = "Standard style for JavaScript code out-of-box";
    homepage = "https://standardjs.com";
    inherit (nodejs.meta) platforms;
  };
}

