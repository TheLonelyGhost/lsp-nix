{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.typescript-language-server.override {
  meta = {
    description = "Language Server Protocol implementation for TypeScript wrapping tsserver.";
    homepage = "https://github.com/typescript-language-server/typescript-language-server";
    inherit (nodejs.meta) platforms;
  };
}
