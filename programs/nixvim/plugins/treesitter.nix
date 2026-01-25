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
        latex
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
        typst
        vim
        xml
        yaml
        zig
      ];

      nixvimInjections = true;

      highlight.enable = true;
      indent = {
        enable = false;
      };
      folding.enable = false;
    };

    hmts.enable = true;
  };
}
