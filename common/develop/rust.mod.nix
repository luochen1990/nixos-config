{ config, pkgs, lib, ... }: 
{
  imports = [
    ./c.mod.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      #rustc rustup cargo #use rust-overlay instead
    ];
  };
}
