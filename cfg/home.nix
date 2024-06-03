{ config, pkgs, inputs, lib,  ... }:

{ 
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "virus-free";
  home.homeDirectory = "/home/virus-free";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; 
  [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    fastfetch ripgrep eza
    mtr glow broot 
    neovide alacritty
    vscodium-fhs
    youtube-dl lazygit
    aria unp dust
    zoxide hyfetch
    ptyxis
    # Secrets
    minisign sops age
    # GUI
    keepassxc mupdf 
    caprine-bin joplin-desktop
    sioyek koreader emote
    # LSP's
    nil # Nix language server
    # Fonts
    fira-code-nerdfont jetbrains-mono
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/virus-free/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
    SHELL = "fish";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zellij = {
    enable = true;
    catppuccin.enable = true;
    enableFishIntegration = true;
  };

  programs.bottom = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.helix = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.starship = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.mpv = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("Fira Code Nerd Font Mono"),
        default_prog = { "fish", "-l" }
      }
    '';
  };

  programs.fish = {
    enable = true;
    catppuccin.enable = true;
    functions = {
      mountShtuffs = "sudo mount -t btrfs -o user,rw,exec,compress=zstd /dev/disk/by-uuid/17d12767-23df-47f0-921f-9dbf544a7f82 /mnt/Shtuffs";
      cdShtuffs = "cd /mnt/Shtuffs";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Oliver Ladores";
    userEmail = "oliver.ladores@wvsu.edu.ph";
    signing.key = "0x320B1B0E0E392BE6";
    # extraConfig.core.sparseCheckout
  };

  programs.gitui = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    catppuccin.enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      shell.program = "fish";
      window = {
        dynamic_padding = true;
        decorations = "None";
        opacity = 0.95;
        startup_mode = "Fullscreen";
      };
      font.normal.family = "Fira Code Nerd Font";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.gpg.enable = true;
  programs.gpg.publicKeys = [
    { source = "${ pkgs.fetchurl { 
      url = "https://keys.openpgp.org";
      hash = "sha256-xWjMw8xYN+o/6Yma3YOQB02EghrbdyFxEQp8TRtEtq0=";
    }}"; }
  ];
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gtk2;

  programs.nixvim = {
    enable = true;
    # copied from github:GaetanLepage/dotfiles
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = let
      normal =
        lib.mapAttrsToList
        (key: action: {
          mode = "n";
          inherit action key;
        })
        {
          "<Space>" = "<NOP>";

          # Esc to clear search results
          "<esc>" = ":noh<CR>";

          # fix Y behaviour
          Y = "y$";

          # back and fourth between the two most recent files
          "<C-c>" = ":b#<CR>";

          # close by Ctrl+x
          # "<C-x>" = ":close<CR>";

          # save by Space+s or Ctrl+s
          "<leader>s" = ":w<CR>";
          "<C-s>" = ":w<CR>";

          # navigate to left/right window
          "<leader>h" = "<C-w>h";
          "<leader>l" = "<C-w>l";

          # Press 'H', 'L' to jump to start/end of a line (first/last character)
          L = "$";
          H = "^";

          # resize with arrows
          "<C-Up>" = ":resize -2<CR>";
          "<C-Down>" = ":resize +2<CR>";
          "<C-Left>" = ":vertical resize +2<CR>";
          "<C-Right>" = ":vertical resize -2<CR>";

          # move current line up/down
          # M = Alt key
          "<M-k>" = ":move-2<CR>";
          "<M-j>" = ":move+<CR>";
        };
      visual =
        lib.mapAttrsToList
        (key: action: {
          mode = "v";
          inherit action key;
        })
        {
          # better indenting
          ">" = ">gv";
          "<" = "<gv";
          "<TAB>" = ">gv";
          "<S-TAB>" = "<gv";

          # move selected line / block of text in visual mode
          "K" = ":m '<-2<CR>gv=gv";
          "J" = ":m '>+1<CR>gv=gv";
        };
    in
      config.nixvim.helpers.keymaps.mkKeymaps
      {options.silent = true;}
      (normal ++ visual);
    # --| from github:GaetanLepage
    colorschemes.oxocarbon.enable = true;
    plugins = {
      # Treesitter
      treesitter.enable = true;
      treesitter.indent = true;
      treesitter.incrementalSelection.enable = true;
      treesitter.folding = true;
      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      # UI + Conveniences
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          {name = "nvim_lsp";}
      	  {name = "path";}
      	  {name = "buffer";}
          {name = "nvim_lsp_document_symbol";}
          {name = "nvim_lsp_signature_help";}
      	  {name = "emoji";}
      	  {name = "latex_symbols";}
          {name = "luasnip";}
      	];
      	settings.mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      	};
        settings.snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-emoji.enable = true;
      cmp-latex-symbols.enable = true;
      cmp_luasnip.enable = true;
      nvim-autopairs.enable = true;
      luasnip.enable = true;
      indent-blankline.enable = true;
      comment.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
      oil.enable = true;
      gitsigns.enable = true;
      flash.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      which-key.enable = true;
      wilder.enable = true;
      jupytext.enable = true;
      # Linters
      lint = {
        enable = true;
      };
      # Languages
      lsp = {
        enable = true;
      	keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>ck" = "goto_prev";
            "<leader>cj" = "goto_next";
            "<leader>cc" = "open_float";
            "<leader>K" = "show";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };
        servers = {
          # Nix
          nil_ls = {
            enable = true;
            package = null;
          };
          # Rust
          #  rust-analyzer = {
          #    enable = true;
          #   installCargo = false;
          #   installRustc = false;
          # };
          # Python
          pyright.enable = true;
          ruff-lsp.enable = true;
          # Typst
          tinymist.enable = true;
          tinymist.filetypes = [ "typst" "typ" ];
          # Markdown
          marksman.enable = true;
          # Deno
          denols.enable = true;
          # C
          ccls.enable = true;
          # Lua
          lua-ls.enable = true;
        };
      };
      # Additional Rust stuff
      crates-nvim.enable = true;
      rustaceanvim.enable = true;
      # HTML Templating
      ts-autotag = {
        enable = true;
        filetypes = [ "html" "javascript" "typescript" "javascriptreact" "typescriptreact" "svelte"
                      "vue" "tsx" "jsx" "rescript" "xml" "php" "markdown" "astro" "glimmer" 
                      "handlebars" "hbs" "vento" ];
      };
    };
    extraConfigVim = ''
      set shiftwidth=2 softtabstop=2 expandtab
    '';
  };
  # Fonts
  fonts.fontconfig.enable = true;
  # Desktop Appearance
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";
  gtk = {
    enable = true;
    catppuccin.enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-gtk";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # gtk-theme = "Catppuccin-Frappe-Standard-Blue-light";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-dark";
    };
  };
  xdg.enable = true;
}
