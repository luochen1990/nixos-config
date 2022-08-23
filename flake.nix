/*
Usage: 

`nixos-rebuild switch --flake .`

The above command auto decide which profile to use via `hostname`.

If you want to specify profile name manually, use following command instead:

`nixos-rebuild switch --flake .#<profileName>`
*/

{
  description = "My NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-cn.url = "github:nixos-cn/flakes";
    nixos-cn.inputs.nixpkgs.follows = "nixpkgs";
    nixos-cn.inputs.flake-utils.follows = "flake-utils";
    #home-manager = {url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    #rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    #resign = { url = "github:NickCao/resign"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@extra-args: 
    #flake-utils.lib.eachDefaultSystem (system:
    let system = "x86_64-linux"; in
    let pkgs = nixpkgs.legacyPackages.${system}; in
    let lib = nixpkgs.lib; in
    let subDirs = (path: with builtins; let d = readDir path; in filter (k: d.${k} == "directory") (attrNames d)); in
    {
      nixosConfigurations = lib.genAttrs (subDirs ./profiles) (profileName:
        lib.nixosSystem rec {
          inherit system;
          specialArgs = extra-args // {inherit system;};
          modules = [
            {
              inherit profileName; 
              nix.settings.nix-path = [ "nixpkgs=${nixpkgs}" ];
            }
            (./profiles + "/${profileName}/configuration.nix")
          ];
        }
      );
    };
    #});
}
