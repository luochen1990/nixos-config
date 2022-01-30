{ config, pkgs, lib, ... }: 
{
  #Ref: https://nixos.wiki/wiki/Node.js

  config = {
    environment.systemPackages = with pkgs; [
      nodejs
    ];
  };
}
