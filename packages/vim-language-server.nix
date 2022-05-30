{ pkgs, nodejs ? pkgs.nodejs-14_x }:

let
  npm = import ../npm {
    inherit pkgs nodejs;
  };
in
npm.vim-language-server.override {
  meta = {
    description = "A language server for VimScript";
    homepage = "https://github.com/iamcco/vim-language-server";
    platforms = nodejs.meta.platforms;
  };
}
