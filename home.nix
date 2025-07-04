{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    (import ./nixvim.nix {inherit config pkgs inputs lib;})
  ];
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
  home.packages = with pkgs; [
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
    # Tools
    fastfetch
    ripgrep
    eza
    broot
    neovide
    alacritty
    xh
    ouch
    dust
    zoxide
    ffmpeg-full
    fabric-ai
    tpm2-tools
    comma
    wl-clipboard-rs
    wineWowPackages.staging
    winetricks
    # Dev tooling
    devenv
    pijul
    # Secrets
    minisign
    sops
    age
    # GUI
    keepassxc
    mupdf
    sioyek
    emote
    maliit-keyboard
    # LSP's
    nil # Nix language server
    # Vivaldi
    (vivaldi.overrideAttrs (
      finalAttrs: previousAttrs: {
        dontWrapQtApps = false;
        dontPatchElf = true;
        nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [pkgs.kdePackages.wrapQtAppsHook];
      }
    ))
    # Document writing
    typst
    asciidoctor-with-extensions
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
    SHELL = "nu";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "nu";
      default_mode = "locked";
      theme = "dracula";
    };
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
    package = pkgs.evil-helix;
    extraPackages = with pkgs; [
      tinymist
      markdown-oxide
      harper
      vscode-langservers-extracted
      emmet-language-server
    ];
    settings.theme = "darcula-solid";
    settings.editor = {
      text-width = 120;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      soft-wrap = {
        enable = true;
      };
    };
    languages = {
      language-server = {
        harper-ls = {
          command = "harper-ls";
          args = ["--stdio"];
        };
        emmet = {
          command = "emmet-language-server";
          args = ["--stdio"];
        };
      };
      language = [
        {
          name = "markdown";
          language-servers = [
            "markdown-oxide"
            "harper-ls"
          ];
          text-width = 120;
        }
        {
          name = "typst";
          language-servers = [
            "tinymist"
            "harper-ls"
          ];
          text-width = 120;
        }
        {
          name = "html";
          language-servers = [
            "vscode-html-language-server"
            "harper-ls"
            "emmet"
          ];
        }
      ];
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "the-dark-side"
    ];
  };

  programs.pandoc = {
    enable = true;
    defaults = {
      metadata.author = "Oliver Ladores";
      pdf-engine = "typst";
    };
  };

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship/jetpack.toml);
  };

  programs.mpv = {
    enable = true;
  };

  programs.yt-dlp.enable = true;

  programs.kitty = {
    enable = true;
    font.name = "Fira Code Nerd Font";
    extraConfig = ''
      shell nu
    '';
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      skim
      polars
      highlight
      gstat
    ];
    shellAliases = {
      g = "git";
    };
    extraConfig = ''
      source ~/.cache/carapace/init.nu
    '';
    extraEnv = ''
      $env.EDITOR = 'hx'
      $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
      mkdir ~/.cache/carapace
      carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
    '';
  };

  programs.fish = {
    enable = true;
    # functions = {
    #   mountShtuffs = "sudo mount -t btrfs -o user,rw,exec,compress=zstd /dev/disk/by-uuid/17d12767-23df-47f0-921f-9dbf544a7f82 /mnt/Shtuffs";
    #   cdShtuffs = "cd /mnt/Shtuffs";
    # };
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
    lfs.enable = true;
    # extraConfig.core.sparseCheckout
  };

  programs.gitui = {
    enable = true;
  };

  programs.skim = {
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
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.rclone.enable = true;

  programs.gpg.enable = true;
  programs.gpg.publicKeys = [
    {
      source = "${pkgs.fetchurl {
        url = "https://keys.openpgp.org";
        hash = "sha256-xWjMw8xYN+o/6Yma3YOQB02EghrbdyFxEQp8TRtEtq0=";
      }}";
    }
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-freeze-filter
    ];
  };

  programs.nix-index.enable = true;

  services.ssh-agent.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;
  # Fonts
  fonts.fontconfig.enable = true;
  # Desktop Appearance
  gtk = {
    enable = true;
  };
  qt = {
    enable = true;
  };
  xdg.enable = true;
}
