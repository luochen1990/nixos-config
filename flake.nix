{
  description = "My NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    #home-manager = {url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs }: { #, rust-overlay }: {

    nixosConfigurations = let
        dirContents = builtins.readDir ./profiles;
        profileNames = builtins.filter (name: dirContents.${name} == "directory") (builtins.attrNames dirContents);

        profileEntry = profileName: let
          profilePath = (./profiles + "/${profileName}");
          config = { inherit profileName; };

          defaultProfile = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              #({ pkgs, ... }: {
              #  nixpkgs.overlays = [ rust-overlay.overlay ];
              #  environment.systemPackages = [ ( pkgs.rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; } ) ];
              #})
              config
              (./profiles + "/${profileName}/configuration.nix")
              #home-manager.nixosModules.home-manager
              #{
              #  home-manager.useGlobalPkgs = true;
              #  home-manager.useUserPackages = true;
              #  home-manager.users.lc = import ./home.nix;
              #}
            ];
          };
        in {
          name = profileName;
          value = if builtins.pathExists (profilePath + "/default.nix")
            then import profilePath nixpkgs config
            else defaultProfile;
        };

        profiles = builtins.listToAttrs (builtins.map profileEntry profileNames);

    in profiles // {
      # use command `hostname` to check your current host name
      # NOTE: for adhoc use case, please use `nixos-rebuild switch --flake /path/of/dir/which/contains/flake-dot-nix/#{profileName}` instead.
      #"lc-nixos" = profiles.pocket-nixos;
      #"nixos" = profiles.wsl-nixos; #be careful about enable this alias, since nixos is the default host name for system which installed from iso
    };
  };
}
