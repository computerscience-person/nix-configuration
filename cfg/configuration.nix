# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.home-manager.nixosModules.home-manager
      inputs.sops.nixosModules.sops
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
  };

  fileSystems = {
    "/mnt/Shtiffiesh".options = [ "compress=zstd" "user" "rw" "exec" ];
  };


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_PH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_NAME = "fil_PH";
    LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "fil_PH";
  };

  # Modify udisks defaults
  services.udisks2.enable = true;
  services.udisks2.settings = {
    "udisks2.conf" = {
      defaults = {
        encryption = "luks2";
        btrfs_defaults = "compress=zstd";
      };
      udisks2 = {
        modules = [
          "*"
        ];
        modules_load_preference = "ondemand";
      };
  };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.slick.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "ph";
    xkbVariant = "";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-xapp
    pkgs.xdg-desktop-portal-gtk
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr epson-escpr2
  ];

  # Enable sound with ipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # TODO: Enable when extraLuaConfig option is available.
    # wireplumber.extraConfig.bluetooth."51-bluez-config" = {
    #   bluez_monitor.properties = {
    #     "bluez5.enable-sbc-xq" = true;
    #     "bluez5.enable-msbc" = true;
    #     "bluez5.enable-hw-volume" = true;
    #     "bluez5.headset-roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    #   };
    # };
    #
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '')
    ];
    #
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.blueman.enable = true;
  services.flatpak = {
    enable = true;
    packages = [
      "com.vivaldi.Vivaldi"
      "org.signal.Signal"
      "com.github.vkohaupt.vokoscreenNG"
      "io.github.flattool.Warehouse"
      "com.github.tchx84.Flatseal"
      "org.kde.krita"
      "io.gitlab.adhami3310.Impression"
      "us.zoom.Zoom"
      "com.discordapp.Discord"
    ];
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable graphics and openGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      
    ];
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.virus-free = {
    isNormalUser = true;
    description = "Oliver Ladores";
    extraGroups = [ "networkmanager" "wheel" "tss" "adbusers" ];
    packages = with pkgs; [
    # firefox
    #  thunderbird
    wine64
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nix.settings = {
    substituters = [
      "https://cache.lix.systems"
      "https://nix-community.cachix.org"
      "https://typst-nix.cachix.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "typst-nix.cachix.org-1:OzDUMt0nd4wlI1AHucBPnchl4utWXeFTtUFt8XZ3DbA"
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    home-manager
    xfce.thunar-volman
    # xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-sensors-plugin
    xfce.xfce4-netload-plugin
    xfce.xfce4-dict
    xfce.xfce4-volumed-pulse
    btrfs-progs
    btrfs-assistant
    ntfs3g
    appimage-run
    distrobox
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DroidSansMono" "UbuntuMono"];})
    nerd-fonts.fira-code nerd-fonts.jetbrains-mono nerd-fonts.droid-sans-mono nerd-fonts.ubuntu-mono
  ];

  programs.adb.enable = true;
  programs.nix-ld.enable = true;

  services.openssh.enable = true;

  services.dbus.packages = [ pkgs.gcr ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers = {
      enable = true;
      # containersConf = ''
      #   [engine]
      #   volume_path = "/mnt/Shtiffiesh/var/lib/containers/storage/volumes"
      # '';
      storage.settings = {
        storage.rootless_storage_path = "/mnt/Shtiffiesh/var/lib/containers/storage";
        storage.driver = "btrfs";
      };
    };
  };

  # Secrets (sops)
  sops.defaultSopsFile = ./.sops.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/virus-free/.config/sops/age/keys.txt";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 6969 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
