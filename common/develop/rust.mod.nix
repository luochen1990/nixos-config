{ config, pkgs, lib, ... }: 
{
  imports = [
    ./c.mod.nix
  ];

  config = {

    #({ pkgs, ... }: {
    #  nixpkgs.overlays = [ rust-overlay.overlay ];
    #  environment.systemPackages = [ ( pkgs.rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; } ) ];
    #})

    environment.systemPackages = with pkgs; [
      #rustc rustup cargo #use rust-overlay instead
    ];
  };
}
