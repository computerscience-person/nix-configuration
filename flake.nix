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
    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager, ...} @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./cfg/configuration.nix
        ];
      };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .  #your-username@your-hostname'
    homeConfigurations = {
    "virus-free" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { 
          inherit system;
          config.allowUnfree = true;
      };
      extraSpecialArgs = {inherit inputs;};
      # > Our main home-manager configuration file <
      modules = [
        ./cfg/home.nix
        ];
      };
    };
  };
}
