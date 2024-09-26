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
    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-unstable.url = "git+file:./nixpkgs?ref=nixos-unstable&shallow=1";
    nixos-local.url = "git+file:./nixpkgs?ref=local&shallow=1";
    nixos-master.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixos-local";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixos-local";
    vscode-server.inputs.flake-utils.follows = "flake-utils";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixos-local";
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixos-local";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixos-local";
    nix-alien.inputs.flake-utils.follows = "flake-utils";
    nix-alien.inputs.nix-index-database.follows = "nix-index-database";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixos-local";
    #nix-init.url = "github:nix-community/nix-init";
    #nix-init.inputs.nixpkgs.follows = "nixos-local";
    #rust-overlay.url = "github:oxalica/rust-overlay";
    #rust-overlay.inputs.nixpkgs.follows = "nixos-local";
    resign.url = "github:NickCao/resign";
    resign.inputs.nixpkgs.follows = "nixos-local";
    resign.inputs.flake-utils.follows = "flake-utils";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixos-local";
    microvm.inputs.flake-utils.follows = "flake-utils";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    distro-grub-themes.inputs.nixpkgs.follows = "nixos-local";
    distro-grub-themes.inputs.flake-utils.follows = "flake-utils";
    nix-fast-build.url = "github:Mic92/nix-fast-build";
    nix-fast-build.inputs.nixpkgs.follows = "nixos-master"; #NOTE: to avoid nix-2.24.5 #TODO: use nixos-local
    nix-fast-build.inputs.flake-parts.follows = "flake-parts";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixos-local";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    #nixos-cosmic.inputs.nixpkgs.follows = "nixos-local"; #为了用上缓存，就别follow了 :(
    nixos-cosmic.inputs.nixpkgs-stable.follows = "nixos-stable";
    #nixos-cosmic.inputs.rust-overlay.follows = "rust-overlay";
  };

  outputs = inputs@{ self, nixos-local, nixos-stable, nixos-master, ... }:
  let
    # tools
    lib = nixos-local.lib;
    tools' = let t = (import ./tools); in t // t.useLib lib;
    inherit (tools') for unionFor subDirs findFiles dict;

    systemContext = system: rec {
      inherit system;
      nixpkgs-config = {allowUnfree = true; nvidia.acceptLicense = true;};
      pkgs = import nixos-local { inherit system; config = nixpkgs-config;};
      pkgs-stable = import nixos-stable { inherit system; config = nixpkgs-config // {permittedInsecurePackages = ["openssl-1.1.1w"];};};
      pkgs-master = import nixos-master { inherit system; config = nixpkgs-config;};
      packages = unionFor (subDirs ./packages) (x: {"${x}" = pkgs.callPackage (./packages + "/${x}") {}; });
      tools = tools' // tools'.usePkgs pkgs;
      specialArgs = {inherit self system packages pkgs-stable pkgs-master inputs tools;};
    };
    eachSystem' = supportedSystems: f: dict supportedSystems (system: f (systemContext system));
    eachSystem = eachSystem' lib.systems.flakeExposed;

    # context
    modules = unionFor (subDirs ./modules) (x: {"${x}" = import (./modules + "/${x}"); });
    modules_list = for (builtins.attrNames modules) (k: modules.${k});
  in
  {
    # 给 nix repl . 用的
    inherit (systemContext "x86_64-linux") pkgs pkgs-master pkgs-stable specialArgs tools; #TODO: for other system

    # 正儿八经的 flake outputs
    nixosConfigurations =
    let
      system = "x86_64-linux";
      inherit (systemContext system) specialArgs;
    in
    unionFor (subDirs ./profiles) (profileName:
    {
      "${profileName}" = nixos-local.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // specialArgs // {inherit profileName; };
        modules = [
          (./profiles + "/${profileName}/configuration.nix")
        ] ++ modules_list;
      };
    });

    nixosModules = modules // { default = (import ./modules); };

    packages = eachSystem ({system, packages, specialArgs, ...}: packages //
    unionFor (subDirs ./profiles) (profileName:
    unionFor ["docker" "amazon" "raw" "iso"] (format:
    {
      "images__${profileName}__${format}" = inputs.nixos-generators.nixosGenerate {
        inherit system format;
        specialArgs = inputs // specialArgs // {inherit profileName; };
        modules = [
          (./profiles + "/${profileName}/configuration.nix")
        ] ++ modules_list;
      };
    })));

    # # 给 home-manager 命令用的, 暂时没用上，先不维护了
    # homeConfigurations =
    # let
    #   system = "x86_64-linux";
    #   inherit (systemContext system) pkgs;
    # in
    # unionFor (subDirs ./fact/user) (userName:
    # {
    #   "${userName}" = inputs.home-manager.lib.homeManagerConfiguration {
    #     pkgs = pkgs;

    #     modules = [
    #       import (./fact/user + "/${userName}/home.nix")
    #       import (./fact/user + "/${userName}/plasma.home.nix")
    #       inputs.plasma-manager.homeManagerModules.plasma-manager
    #     ];
    #   };
    # });

  };
}
