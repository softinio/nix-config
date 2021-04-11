{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "salar";
  home.homeDirectory = "/Users/salar";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "$EDITOR";
  };

  programs.bat = {
      enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

  programs.gh = {
    enable = true;
    editor = "nvim";
    gitProtocol = "ssh";
  };

  programs.git = {
    enable = true;
    userEmail = "code@softinio.com";
    userName = "Salar Rahmanian";
    ignores = [
      "*~"
      ".DS_Store"
      "*.bloop"
      "*.metals"
      "*.metals.sbt"
      "*metals.sbt"
      "*.direnv"
      "*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
      "*hie.yaml" # ghcide files
      "*.mill-version" # used by metals
      "*.idea"
      "*.vscode"
      "*.python-version"
    ];
    extraConfig = {
      core = {
        editor = "nvim";
      };
      github.user = "softinio";
      merge.tool = "intellij";
      mergetool = {
        cmd = "idea merge \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"";
        trustExitCode = true;
        prompt = false;
      };
      diff.tool = "intellij";
      difftool = {
        cmd = "idea diff \"$LOCAL\" \"$REMOTE\"";
        prompt = false;
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
      pull = {
        rebase = true;
      };
    };
  };

  programs.htop = {
    enable = true;
    sortDescending = true;
    sortKey = "PERCENT_CPU";
  };

  programs.jq = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      character.symbol = "λ";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      ack-vim
      auto-pairs
      coc-nvim
      coc-java
      coc-json
      coc-metals
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
    ];
    extraConfig = ''
        set directory=$HOME/.vim/swapfiles/swap//
        set undodir=~/.vim/swapfiles/undo//
        set backupdir=~/.vim/swapfiles/backup//
        " Make those folders automatically if they don't already exist.
        if !isdirectory(expand(&undodir))
            call mkdir(expand(&undodir), "p")
        endif
        if !isdirectory(expand(&backupdir))
            call mkdir(expand(&backupdir), "p")
        endif
        if !isdirectory(expand(&directory))
            call mkdir(expand(&directory), "p")
        endif
        set t_Co=256
        set encoding=utf-8
        syntax on
        set expandtab
        set hidden
        set showmatch
        set colorcolumn=120
        set cursorcolumn
        set cursorline
        set cmdheight=2
        set smarttab
        set linebreak
        set hlsearch
        set ignorecase
        set incsearch
        set guifont=SF\ Mono:h12
        set termguicolors
        let g:clipboard = {
              \ 'name': 'pbcopy',
              \ 'copy': {
              \    '+': 'pbcopy',
              \    '*': 'pbcopy',
              \  },
              \ 'paste': {
              \    '+': 'pbpaste',
              \    '*': 'pbpaste',
              \ },
              \ 'cache_enabled': 0,
              \ }
        set clipboard=unnamed
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
        let g:seoul256_background = 233
        let g:seoul256_srgb = 1
        colorscheme seoul256
        set background=dark
        set number
        let g:netrw_banner=0        " disable annoying banner
        let g:netrw_browse_split=4  " open in prior window
        let g:netrw_altv=1          " open splits to the right
        let g:netrw_liststyle=3     " tree view
        let g:netrw_list_hide=netrw_gitignore#Hide()
        let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
        let g:netrw_list_hide= '.*\.pyc$'
        au BufRead,BufNewFile *.sbt set filetype=scala
        if executable("rg")
            set grepprg=rg\ --vimgrep\ --no-heading
            set grepformat=%f:%l:%c:%m,%f:%l:%m
        endif
        let g:ackprg='rg --vimgrep --no-heading'
        set grepprg=rg\ --vimgrep
        let g:rg_command = 'rg --vimgrep -S'
        let mapleader = "\<space>"
        map! jj <ESC>
        " FZF
        set rtp+=/Users/salar/.nix-profile/bin/fzf
        imap <c-x><c-o> <plug>(fzf-complete-line)
        map <leader>b :Buffers<cr>
        map <leader>f :Files<cr>
        map <leader>g :GFiles<cr>
        map <leader>y :Tags<cr>
        autocmd! FileType fzf tnoremap <buffer> <leader>q <c-c>
        nnoremap <C-p> :FZF<CR>

        let g:rainbow_active = 1
        let g:rainbow_conf = {
            \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
            \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
            \   'operators': '_,_',
            \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
            \   'separately': {
            \       '*': {},
            \       'tex': {
            \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
            \       },
            \       'lisp': {
            \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
            \       },
            \       'vim': {
            \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
            \       },
            \       'html': {
            \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
            \       },
            \       'css': 0,
            \   }
            \}
            let g:lightline = {
              \ 'colorscheme': 'seoul256',
              \ 'active': {
              \   'left': [ [ 'mode', 'paste' ],
              \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
              \ },
              \ 'component_function': {
              \   'gitbranch': 'FugitiveHead'
              \ },
            \ }

        " Nerdtree Configuration
        let NERDTreeIgnore=['\.pyc$', '\~$', 'target'] "ignore files in NERDTree
        let NERDTreeRespectWildIgnore=1
        let NERDTreeQuitOnOpen=1
        map <leader>m :NERDTreeToggle<CR>
        " jump back to nerdtree
        map <leader>n :NERDTree<CR>
        " reveal in side bar
        map <leader>e :NERDTreeFind<CR>
        let NERDTreeShowHidden=1
        "nerdtree-git-plugin
        let g:NERDTreeGitStatusIndicatorMapCustom= {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Unknown"   : "?"
            \ }

        " Switch to previous buffer mapped to tab
        function SwitchBuffer()
          b#
        endfunction

        nmap <A-Tab> :call SwitchBuffer()<CR>

        " split-term
        let g:split_term_default_shell = "fish"
        let g:split_term_vertical = 1

        " START Configuration for coc.nvim
        " --------------------------------
        " Better display for messages
        set cmdheight=2

        " You will have bad experience for diagnostic messages when it's default 4000.
        set updatetime=300

        " don't give |ins-completion-menu| messages.
        set shortmess+=c

        " always show signcolumns
        set signcolumn=yes

        " Use tab for trigger completion with characters ahead and navigate.
        " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " Use <c-space> to trigger completion.
        inoremap <silent><expr> <c-space> coc#refresh()

        " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
        " Coc only does snippet and additional edit on confirm.
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        " Or use `complete_info` if your vim support it, like:
        " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

        " Use `[g` and `]g` to navigate diagnostics
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Use K to show documentation in preview window
        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          else
            call CocAction('doHover')
          endif
        endfunction

        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " Remap for rename current word
        nmap <leader>rn <Plug>(coc-rename)

        " Remap for format selected region
        xmap <leader>l  <Plug>(coc-format-selected)
        nmap <leader>l  <Plug>(coc-format-selected)

        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json,scala setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        " Remap for do codeAction of current line
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)

        " Create mappings for function text object, requires document symbols feature of languageserver.
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)

        " Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
        nmap <silent> <TAB> <Plug>(coc-range-select)
        xmap <silent> <TAB> <Plug>(coc-range-select)

        " Use `:Format` to format current buffer
        command! -nargs=0 Format :call CocAction('format')

        " Use `:Fold` to fold current buffer
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)

        " use `:OR` for organize import of current buffer
        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

        " Using CocList
        " Show all diagnostics
        nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions
        nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
        " Show commands
        nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document
        nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols
        nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list
        nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

        " Notify coc.nvim that <enter> has been pressed.
        " Currently used for the formatOnType feature.
        inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        " Toggle panel with Tree Views
        nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
        " Toggle Tree View 'metalsBuild'
        nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
        " Toggle Tree View 'metalsCompile'
        nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
        " Reveal current current class (trait or object) in Tree View 'metalsBuild'
        nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsBuild<CR>

        nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

        '';
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "50eba266b0d8a952c7230fca1114cbc9fbbdfbd4";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      }
    ];

    loginShellInit = ''
      set -xg TERM xterm-256color
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end

      set -xg PATH $HOME/bin $PATH

      set -xg JAVA_HOME /Users/salar/.nix-profile/bin

      set -xg NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH

      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n

      set -xg TOOLCHAINS swift
      '';

    promptInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      cat="bat";
      du="ncdu --color dark -rr -x";
      ping="prettyping";
      ".." = "cd ..";
      pj="python -m json.tool";
      l="exa --long --header --git --all";
      g="git";
      gl="git log";
      gc="git commit -m";
      gca="git commit -am";
      gws="git status";
      ghauth="gh auth login --with-token < ~/.ghauth";
      gforksync="git fetch upstream && git merge upstream/master && git push origin master";
      grep="grep --color=auto";
      new-sbt="sbt new scala/scala-seed.g8";
      nixre="home-manager switch";
      nixedit="home-manager edit";
      nixgc="nix-collect-garbage -d";
      nixq="nix-env -qa";
      nixupdate="nix-channel --update";
      nixupgrade="nix upgrade-nix";
      nixup="nix-env -u";
      nixversion="nix eval nixpkgs.lib.version";
      nixdaemon="sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist && launchctl start org.nixos.nix-daemon";
      v="nvim";
      tabninecfg="vc /Users/salar/Library/Preferences/TabNine/TabNine.toml";
      sshfre1="ssh salar@fre1.softinio.net";
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';

  home.packages = [
    pkgs.awscli
    pkgs.pgcli
    pkgs.tig
    pkgs.ripgrep
    pkgs.hugo
    pkgs.jansson
    pkgs.universal-ctags
    pkgs.httpie
    pkgs.global
    pkgs.fd
    pkgs.curlFull
    pkgs.wget
    pkgs.readline
    pkgs.tree
    pkgs.exa
    pkgs.openssl
    pkgs.xz
    pkgs.gitAndTools.diff-so-fancy
    pkgs.ranger
    pkgs.gnupg
    pkgs.niv
    pkgs.ffmpeg
    pkgs.gradle
    pkgs.maven
    pkgs.procs
    pkgs.shellcheck
    pkgs.cabal-install
    pkgs.hlint
    pkgs.ghcid
    pkgs.pandoc
    pkgs.multimarkdown
    pkgs.direnv
    pkgs.nixfmt
    pkgs.cmake
    pkgs.any-nix-shell
    pkgs.asciinema
    pkgs.ncdu
    pkgs.prettyping
    pkgs.rnix-lsp
    pkgs.aspell
    pkgs.procs
    pkgs.dust
    pkgs.tokei
    pkgs.tealdeer
    pkgs.hyperfine
    pkgs.graphviz
    pkgs.neofetch
    pkgs.adoptopenjdk-openj9-bin-16
    pkgs.vscodium
  ];
}
