{ config, pkgs, lib, ... }: 
{
  environment.systemPackages = with pkgs; [
    nixos-generators
  ];
}
