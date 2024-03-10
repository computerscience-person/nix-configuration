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
    neofetch ripgrep eza
    mtr glow broot 
    neovide bottom alacritty
    bat vscodium-fhs
    mpv youtube-dl lazygit
    pandoc typst aria
    unp helix dust
    zellij zoxide
    # GUI
    keepassxc mupdf pavucontrol
    blueman
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
    EDITOR = "vim";
    GTK_THEME = "Catppuccin-Mocha-Compact-Rosewater-Lavender-Dark";
    SHELL = "fish";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
  };
  
  programs.git = {
    enable = true;
    userName = "Oliver Ladores";
    userEmail = "oliver.ladores@wvsu.edu.ph";
  };

  programs.zoxide = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "aghfnjkcakhmadgdomlmlhhaocbkloab" # just black
    ];
    # extraOpts = {
    #   "BrowserSignin" = 1;
    #   "SyncDisabled" = false;
    #   "MetricsReportingEnabled" = false;
    # };
  };

  programs.alacritty = {
    enable = true;
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
      	  {name = "emoji";}
      	  {name = "latex_symbols";}
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
      };
      todo-comments.enable = true;
      trouble.enable = true;
      oil.enable = true;
      gitsigns.enable = true;
      flash.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      which-key.enable = true;
      wilder.enable = true;
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
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
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
          rust-analyzer = {
            enable = true;
	    installCargo = false;
	    installRustc = false;
	  };
          # Python
          pyright.enable = true;
          ruff-lsp.enable = true;
          # Typst
          typst-lsp.enable = true;
          # Markdown
          marksman.enable = true;
        };
      };
      # Additional Rust stuff
      crates-nvim.enable = true;
      rust-tools.enable = true;
    };
  };
  # Fonts
  fonts.fontconfig.enable = true;
  # Desktop Appearance
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Rosewater-Lavender-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "rosewater" "lavender" ];
	size = "compact";
	tweaks = [ "rimless" "black" ];
	variant = "mocha";
      };
    };
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
    platformTheme = "gtk";
    style.name = "adwaita-gtk";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # gtk-theme = "Catppuccin-Frappe-Standard-Blue-light";
      gtk-theme = "Catppuccin-Mocha-Compact-Rosewater-Lavender-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-dark";
    };
  };
}
