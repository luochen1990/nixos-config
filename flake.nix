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

    in builtins.listToAttrs (builtins.map (profileName: {
      name = profileName;
      value =  nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { inherit profileName; }
          (./profiles + "/${profileName}/configuration.nix")

          #({ pkgs, ... }: {
          #  nixpkgs.overlays = [ rust-overlay.overlay ];
          #  environment.systemPackages = [ ( pkgs.rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; } ) ];
          #})

          #home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #  home-manager.users.lc = import ./home.nix;
          #}
        ];
      };
    }) profileNames);

    # NOTE: 
    #  The command `nixos-rebuild switch --flake .` choose profile via `hostname`
    #  If you want to specify profile, use `nixos-rebuild switch --flake .#{profileName}` instead.
  };
}
