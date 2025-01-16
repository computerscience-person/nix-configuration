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
    yt-dlp lazygit
    aria unp dust
    zoxide hyfetch
    ffmpeg-full
    # Dev tooling
    devenv
    # Secrets
    minisign sops age
    # GUI
    keepassxc mupdf 
    sioyek emote
    # LSP's
    nil # Nix language server
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
    # enableFishIntegration = true;
  };

  programs.bottom = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.helix = {
    enable = true;
    settings.theme = "darcula-solid";
    settings.editor.cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "underline";
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "the-dark-side"
    ];
  };

  programs.starship = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    # extraConfig = ''
    #   return {
    #     font = wezterm.font("Fira Code Nerd Font Mono"),
    #     default_prog = { "fish", "-l" }
    #   }
    # '';
  };

  programs.kitty = {
    enable = true;
    font.name = "Fira Code Nerd Font";
    extraConfig = ''
      shell fish
    '';
  };

  programs.rio = {
    enable = true;
    settings = {
      fonts.family = "FiraCode Nerd Font";
      shell.program = "fish";
      shell.args = [];
      editor.program = "neovide&";
      editor.args = [];
    };
  };

  programs.fish = {
    enable = true;
    functions = {
      mountShtuffs = "sudo mount -t btrfs -o user,rw,exec,compress=zstd /dev/disk/by-uuid/17d12767-23df-47f0-921f-9dbf544a7f82 /mnt/Shtuffs";
      cdShtuffs = "cd /mnt/Shtuffs";
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "\${pkgs.kitty}/bin/kitty";
    theme = "./rofi/theme/config1.rasi";
  };
  
  programs.git = {
    enable = true;
    userName = "Oliver Ladores";
    userEmail = "oliver.ladores@wvsu.edu.ph";
    signing.key = "0x320B1B0E0E392BE6";
    aliases = {
      st = "status";
      logl = "log --oneline --graph --show-signature";
      br = "branch";
      sw = "switch";
    };
    delta.enable = true;
    # extraConfig.core.sparseCheckout
  };

  programs.gitui = {
    enable = true;
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
    package = pkgs.vivaldi;
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

  services.copyq.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gtk2;

  programs.emacs = {
    enable = true;
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
          # "<Space>" = "<NOP>";

          # Esc to clear search results
          "<esc>" = ":noh<CR>";

          # fix Y behaviour
          # Y = "y$";

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

          # navigate to left/right buffer
          "<leader>bh" = ":bprev<CR>";
          "<leader>bl" = ":bnext<CR>";
          "<leader>bx" = ":bdelete<CR>";

          # lspsaga keymaps
          "<leader>ca" = ":Lspsaga code_action<CR>";
          "<leader>cr" = ":Lspsaga rename<CR>";
          "<leader>co" = ":Lspsaga outline<CR>";
          "<leader>cK" = ":Lspsaga hover_doc<CR>";

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
    clipboard.providers.xsel.enable = true;
    plugins = {
      # Treesitter
      treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        }; 
      };
      treesitter-context.enable = true;
      treesitter-context.settings.line_numbers = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      # UI + Conveniences
      # Nice completions
      coq-nvim.enable = true;
      coq-nvim.installArtifacts = true;
      coq-nvim.settings.auto_start = "shut-up";
      nvim-autopairs.enable = true;
      luasnip.enable = true;
      friendly-snippets.enable = true;
      indent-blankline.enable = true;
      comment.enable = true;
      wrapping.enable = true;
      neoconf.enable = true;
      # Other niceties
      web-devicons.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
      oil.enable = true;
      gitsigns.enable = true;
      flash.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      which-key.enable = true;
      precognition.enable = true;
      wilder.enable = true;
      jupytext.enable = true;
      lspsaga.enable = true;
      lspsaga.lightbulb.debounce = 250;
      # Telescope
      telescope = {
        enable = true;
        keymaps = {
          "<leader>gg" = "live_grep";
          "<leader>gt" = "treesitter";
          "<leader>gG" = "grep_string";
          "<leader>gf" = "find_files";
        };
        extensions = {
          fzf-native.enable = true;
        };
      };
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
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          # Python
          pyright.enable = true;
          # Typst
          tinymist.enable = true;
          tinymist.filetypes = [ "typst" "typ" ];
          # Markdown
          marksman.enable = true;
          # HTML
          superhtml.enable = true;
          superhtml.package = pkgs.superhtml;
          # CSS
          cssls.enable = true;
          # TS/JS
          ts_ls.enable = true;
          # Deno
          denols.enable = true;
          denols.package = null;
          # Tailwind
          tailwindcss.enable = true;
          # C
          clangd.enable = true;
          # Lua
          lua_ls.enable = true;
          # OCaml
          ocamllsp.enable = true;
          ocamllsp.package = null;
          # Dart
          dartls.enable = true;
          # PHP
          phpactor.enable = true;
          phpactor.package = null;
        };
      };
      # Additional Rust stuff
      crates-nvim.enable = true;
      # rustaceanvim.enable = true;
      # HTML Templating
      ts-autotag = {
        enable = true;
      };
      # Markdown
      render-markdown.enable = true;
    };
    extraConfigVim = ''
      set shiftwidth=2 softtabstop=2 expandtab relativenumber
    '';
    extraConfigLua = ''
      if vim.g.neovide then
        vim.g.neovide_scale_factor = 0.8
        local change_scale_factor = function(delta)
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
        end
        vim.keymap.set("n", "<C-=>", function()
          change_scale_factor(1.25)
        end)
        vim.keymap.set("n", "<C-->", function()
          change_scale_factor(1/1.25)
        end)
        vim.g.neovide_remember_window_size = true
        vim.g.neovide_fullscreen = true
        vim.g.neovide_cursor_vfx_mode = "pixiedust"
      end
    '';
  };
  # Fonts
  fonts.fontconfig.enable = true;
  # Desktop Appearance
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
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

  wayland.windowManager.river = {
    enable = true;
    package = null;
    extraConfig = ''
      # Apps
      riverctl map normal Super R spawn 'rofi -show'
      # WM
      riverctl map normal Super Q close
      riverctl map normal Super+Shift Q exit
      riverctl map normal Super H focus-view previous
      riverctl map normal Super L focus-view next
      riverctl map normal Super J focus-output previous
      riverctl map normal Super K focus-output next
      riverctl map normal Super+Alt J send-to-output previous
      riverctl map normal Super+Alt K send-to-output next
      riverctl map normal Super Return zoom
      riverctl map normal Super+Shift Comma send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Super+Shift Period send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal Super Comma send-layout-cmd rivertile "main-count -1"
      riverctl map normal Super Period send-layout-cmd rivertile "main-ration +1"
      # Layout
      riverctl default-layout rivertile
      rivertile -viewpadding 5 -outer-padding 5 &
    '';
  };

  xdg.enable = true;
}
