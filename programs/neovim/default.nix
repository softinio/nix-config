{ config, lib, pkgs, ... }:

let
  custom-plugins = pkgs.callPackage ./custom-plugins.nix {
    inherit (pkgs.vimUtils) buildVimPlugin;
  };

  plugins = pkgs.vimPlugins // custom-plugins;

  overriddenPlugins = with pkgs; [];

  myVimPlugins = with plugins; [
    asyncrun-vim
    ack-vim
    coc-nvim
    coc-java
    coc-json
    coc-metals
    coc-pairs
    coc-python
    coc-tabnine
    fzf-vim
    git-messenger-vim
    lightline-vim
    nerdtree
    nerdtree-git-plugin
    rainbow
    seoul256-vim
    split-term-vim
    vim-fugitive
    vim-gitgutter
    vim-polyglot
  ] ++ overriddenPlugins;

  baseConfig    = builtins.readFile ./config.vim;
  cocConfig     = builtins.readFile ./coc.vim;
  cocSettings   = builtins.toJSON (import ./coc-settings.nix);
  vimConfig     = baseConfig + cocConfig;

in
{
  programs.neovim = {
    enable       = true;
    extraConfig  = vimConfig;
    plugins      = myVimPlugins;
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;
    withNodeJs   = true; # for coc.nvim
    withPython   = true; # for plugins
    withPython3  = true; # for plugins
  };

  xdg.configFile = {
    "nvim/coc-settings.json".text = cocSettings;
  };
}

