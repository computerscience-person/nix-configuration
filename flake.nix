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
  # TODO: Add any other flake you might need
  # hardware.url = "github:nixos/nixos-hardware";
  # Shameless plug: looking for a way to nixify your themes and make
  # everything match nicely? Try nix-colors!
  # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {self,nixpkgs,home-manager,...} @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
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
      modules = [./cfg/home.nix];
      };
    };
  };
}
