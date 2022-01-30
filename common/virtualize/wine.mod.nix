{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      ## [wine] see: https://nixos.wiki/wiki/Wine
      #wineWowPackages.staging
      #wineWowPackages.fonts
      #winetricks
    ];

  };
}
