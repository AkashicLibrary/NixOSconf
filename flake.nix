{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager = {
      # url = "github:nix-community/home-manager";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixos-cosmic = {
      # url = "github:lilyinstarlight/nixos-cosmic";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      homeConfigurations."cynthia" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./cynthia/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      nixosConfigurations = {
        cynthicnix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            # {
              # nix.settings = {
                # substituters = [ "https://cosmic.cachix.org/" ];
                # trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              # };
            # }
            # nixos-cosmic.nixosModules.default
            ./nixos/configuration.nix
          ];
        };
      };
    };

}
