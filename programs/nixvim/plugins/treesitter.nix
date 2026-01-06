{ pkgs, ... }:

{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        awk
        bash
        c
        cpp
        css
        dockerfile
        fish
        git-rebase
        gitattributes
        gitcommit
        gitignore
        go
        haskell
        hocon
        html
        http
        java
        javascript
        json
        json5
        lua
        make
        markdown
        markdown-inline
        nix
        proto
        python
        rust
        scala
        sql
        swift
        terraform
        toml
        typescript
        vim
        xml
        yaml
        zig
      ];

      nixvimInjections = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      folding.enable = false;
    };

    hmts.enable = true;
  };
}
