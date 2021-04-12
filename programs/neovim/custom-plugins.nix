{ buildVimPlugin }:

{
  asyncrun-vim = buildVimPlugin {
    name = "asyncrun-vim";
    src = builtins.fetchTarball {
      name   = "AsyncRun-Vim-v2.7.5";
      url    = "https://github.com/skywind3000/asyncrun.vim/archive/2.7.5.tar.gz";
      sha256 = "02fiqf4rcrxbcgvj02mpd78wkxsrnbi54aciwh9fv5mnz5ka249m";
    };
  };
}
