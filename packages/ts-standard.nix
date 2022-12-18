{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.ts-standard.override {
  meta = {
    description = "Standard style for TypeScript code out-of-box";
    homepage = "https://standardjs.com";
    inherit (nodejs.meta) platforms;
  };
}

