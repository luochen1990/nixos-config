{ config, pkgs, lib, ... }: 
{
  imports = [
    ./c.mod.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      python3
    ];
  };
}
