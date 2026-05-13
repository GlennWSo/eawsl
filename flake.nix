{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fps = {
      url = "github:wamserma/flake-programs-sqlite";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix/release-25.11";

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations = let
      username = "ea";
      system = "x86_64-linux";
      # pkgs = import nixpkgs {inherit system;};
    in {
      "wsl" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          ./core.nix
          (import ./user.nix {inherit username;})
          ./themes/nightfox.nix
          ./configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "back";
              extraSpecialArgs = {inherit username;};
              users.${username} = ./home/ea/headless.nix;
            };
          }
          ({pkgs, ...}: {
            wsl.enable = true;
            wsl.defaultUser = username;
            networking.hostName = "wsl";
            hardware.nvidia.open = true;
            nixpkgs.config.allowUnfree = true;
          })
        ];
      };
    };
  };
}
