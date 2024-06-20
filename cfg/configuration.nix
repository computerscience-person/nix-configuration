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
    catppuccin.enable = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems = {
    "/mnt/Shtiffiesh".options = [ "compress=zstd" "user" "rw" "exec" ];
  };

  catppuccin.flavor = "mocha";

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
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-xapp ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr epson-escpr2
  ];

  # Enable sound with pipewire.
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
    ];
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
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
    extraGroups = [ "networkmanager" "wheel""tss" ];
    packages = with pkgs; [
    # firefox
    #  thunderbird
    wine64
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nix.settings = {
    substituters = [
      "https://cache.lix.systems"
      "https://nix-community.cachix.org"
      "https://typst-nix.cachix.org"
    ];
    trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "typst-nix.cachix.org-1:OzDUMt0nd4wlI1AHucBPnchl4utWXeFTtUFt8XZ3DbA"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  home-manager
  pavucontrol
  xfce.xfce4-volumed-pulse
  xfce.thunar-volman
  btrfs-progs
  btrfs-assistant
  ntfs3g
  appimage-run
  distrobox
  ];

  # home-manager = {
  #   # extraSpecialArgs = { inherit inputs };
  #   users = {
  #     virus-free = import ./home-manager/home.nix ;
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
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
  networking.firewall.allowedTCPPorts = [ 6969 ];
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
