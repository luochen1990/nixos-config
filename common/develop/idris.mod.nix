{ config, pkgs, lib, ... }: 
{
  imports = [
    ./haskell.mod.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      idris idris2
    ];
  };
}
