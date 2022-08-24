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
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    #home-manager.url = "github:nix-community/home-manager";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #rust-overlay.url = "github:oxalica/rust-overlay";
    #rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    #resign.url = "github:NickCao/resign";
    #resign.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }@extra-args: 
    let system = "x86_64-linux"; in
    let pkgs = nixpkgs.legacyPackages.${system}; in
    let lib = nixpkgs.lib; in
    let subDirs = (path: with builtins; let d = readDir path; in filter (k: d.${k} == "directory") (attrNames d)); in
    let for'' = ks: f: with builtins; foldl' (a: b: a // b) {} (map f ks); in
    let prelude_mod = {lib, ...}: { options = {profileName = lib.mkOption {type = lib.types.str;};}; }; in
    {
      nixosConfigurations = lib.genAttrs (subDirs ./profiles) (profileName:
        lib.nixosSystem rec {
          inherit system;
          specialArgs = extra-args // {inherit system;};
          modules = [
            prelude_mod
            { inherit profileName; }
            (./profiles + "/${profileName}/configuration.nix")
          ];
        }
      );
      packages.${system} =
      for'' (subDirs ./profiles) (profileName:
      for'' ["docker" "amazon"] (format:
      {
        "${profileName}_${format}" = nixos-generators.nixosGenerate {
          inherit system;
          inherit format;
          specialArgs = extra-args // {inherit system;};
          modules = [
            prelude_mod
            { inherit profileName; }
            (./profiles + "/${profileName}/configuration.nix")

            (if format == "amazon" then {

              #NOTE: ENA driver fails to build with kernel >= 5.17
              boot.kernelPackages = pkgs.linuxPackages_5_15;

              amazonImage.sizeMB = 16 * 1024;
            } else {})
          ];
        };
      }));
    };
}
