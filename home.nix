{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.sops.homeManagerModules.sops
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
    # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DroidSansMono" "UbuntuMono"];})
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.liberation
    wine64Packages.fonts
    liberation_ttf
    times-newer-roman
    corefonts
    vista-fonts
    stix-two
    fira-math
    lmmath
    atkinson-hyperlegible-next
    atkinson-hyperlegible-mono
    quivira
    (pkgs.callPackage ./packages/catrinity/package.nix {})
    aporetic
    junicode
    gentium
    gentium-book
    andika
    alegreya
    ibm-plex

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # Tools
    nix-output-monitor
    fastfetch
    ripgrep
    eza
    broot
    xh
    ouch
    dust
    bash-env-json
    ffmpeg-full
    tpm2-tools
    comma
    wl-clipboard-rs
    wine-wayland
    winetricks
    android-tools
    # AI Agents
    goose-cli
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
    wireshark
    # LSP's
    nil # Nix language server
    tinymist # Typst
    markdown-oxide # Markdown
    harper # Spellcheck
    vscode-langservers-extracted # HTML/CSS/JS
    emmet-language-server # HTML
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
    typstyle
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

  home.shell.enableNushellIntegration = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "nu";
      default_mode = "locked";
      theme = "dracula";
      keybinds = {
        locked._children = [
          {
            bind = {
              _args = [
                "Alt h"
              ];
              MoveFocusOrTab = ["left"];
            };
          }
          {
            bind = {
              _args = [
                "Alt l"
              ];
              MoveFocusOrTab = ["right"];
            };
          }
        ];
        normal = {
          bind = {
            _args = ["Esc"];
            SwitchToMode._args = ["locked"];
          };
        };
      };
    };
    # enableFishIntegration = true;
  };

  programs.bottom = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batgrep
    ];
    config = {
      theme = "oxocarbon";
    };
    themes = {
      oxocarbon = {
        src = pkgs.fetchFromGitLab {
          owner = "boydkelly";
          repo = "carbonizer";
          rev = "f22aae8c2f9155da0aa5121aa058536549ef4dd5";
          sha256 = "sha256-52sjILLI3KGRWC3kDIYtuZUXo/sPX5ZtqN/uC+uyh38=";
        };
        file = "bat/oxocarbon-dark.tmTheme";
      };
    };
  };

  programs.helix = {
    enable = true;
    package = pkgs.evil-helix;
    extraPackages = with pkgs; [
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
        tinymist.config = {
          exportPdf = "onSave";
          preview.background.enable = "true";
          formatterMode = "typstyle";
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

  programs.sioyek = {
    enable = true;
    config = let
      dracula-theme = pkgs.callPackage ./packages/sioyek-dracula-theme/package.nix {};
    in {
      "source" = "${dracula-theme.src}/dracula.config";
    };
  };

  programs.yt-dlp.enable = true;

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    font.name = "Fira Code Nerd Font";
    themeFile = "Carbonfox";
    extraConfig = ''
      shell nu
    '';
    actionAliases = {
      "launch_tab" = "launch --cwd=current --type=tab";
    };
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      colors = {
        # Dracula theme
        alpha = 0.95;
      };
      main = {
        font = "Fira Code Nerd Font:size=10";
        include = "/home/virus-free/NixOS/extra_config/foot/oxocarbon.ini";
        shell = "nu";
        bold-text-in-bright = "palette-based";
      };
    };
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  programs.pay-respects = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      # skim
      polars
      # highlight
      # gstat
    ];
    shellAliases = {
      g = "git";
      ll = "ls -l";
    };
    settings = {
      completions.algorithm = "fuzzy";
      completions.external.enable = true;
      edit_mode = "vi";
    };
    extraConfig = ''
      use ~/NixOS/scripts/nu/modules/bash-env.nu
      $env.config.hooks.command_not_found = source ${./scripts/nu/nu_scripts/command-not-found/command-not-found.nu}

      let fish_completer = {|spans|
        fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
        | from tsv --flexible --noheaders --no-infer
        | rename value description
        | update value {|row|
          let value = $row.value
          let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
          if ($need_quote and ($value | path exists)) {
            let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
            $'"($expanded_path | str replace --all "\"" "\\\"")"'
          } else {$value}
        }
      }

      # This completer will use carapace by default
      let external_completer = {|spans|
        let expanded_alias = scope aliases
        | where name == $spans.0
        | get -o 0.expansion

        let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
        } else {
            $spans
        }

        match $spans.0 {
          # carapace completions are incorrect for nu
          nu => $fish_completer
          # fish completes commits and branch names in a nicer way
          git => $fish_completer
          # carapace doesn't have completions for asdf
          asdf => $fish_completer
          uv => $fish_completer
          _ => $fish_completer
        } | do $in $spans
      }

      $env.config.completions.external.completer = $external_completer;
    '';
    extraEnv = ''
      $env.EDITOR = 'hx'

      $env.CARAPACE_BRIDGES = 'fish,bash' # optional

      $env.GEMINI_API_KEY = (cat ${config.sops.secrets."AI/GOOGLE_TEST_KEY".path})
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
    settings = {
      user = {
        name = "Oliver Ladores";
        email = "oliver.ladores@wvsu.edu.ph";
      };
      alias = {
        st = "status";
        logl = "log --oneline --graph --show-signature";
        br = "branch";
        sw = "switch";
      };
    };
    signing.key = "0x320B1B0E0E392BE6";
    lfs.enable = true;
    # extraConfig.core.sparseCheckout
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gitui = {
    enable = true;
  };

  programs.skim = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
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
    # enableBashIntegration = true;
    # enableNushellIntegration = true;
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
  services.gpg-agent.pinentry.package = pkgs.pinentry-qt;
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/virus-free/.config/sops/age/keys.txt";
    secrets."AI/GOOGLE_TEST_KEY" = {};
  };
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
  nixpkgs.config.allowUnfree = true;
}
