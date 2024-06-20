{
  description = "computer-science flake configuration.";

  inputs = {
  # Nixpkgs
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  # Home 
  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  # Nixvim
  nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
  sops.url = "github:Mic92/sops-nix";
  lix = {
    url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
    flake = false;
  };
  lix-module = {
    url = "git+https://git.lix.systems/lix-project/nixos-module";
    inputs.lix.follows = "lix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # TODO: Add any other flake you might need
  # hardware.url = "github:nixos/nixos-hardware";
  # Shameless plug: looking for a way to nixify your themes and make
  # everything match nicely? Try nix-colors!
  # nix-colors.url = "github:misterio77/nix-colors";
  catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {self, nixpkgs, home-manager, lix-module, ...} @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        # > Our main nixos configuration file <
        modules = [
          lix-module.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.catppuccin.nixosModules.catppuccin
          ./cfg/configuration.nix
        ];
      };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .  #your-username@your-hostname'
    homeConfigurations = {
    "virus-free" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance 
      extraSpecialArgs = {inherit inputs;};
      # > Our main home-manager configuration file <
      modules = [
        ./cfg/home.nix
        inputs.catppuccin.homeManagerModules.catppuccin
        ];
      };
    };
  };
}
