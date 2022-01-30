# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }: 
{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/prelude
      ../../common/ops
      ../../common/virtualize
    ];

  specialisation = {
    hidpi = {
      configuration = {
        hardware.video.hidpi.enable = true;
        services.xserver.dpi = 180;
      };
    };
    bootstrap = {
      inheritParentConfig = false;
      configuration = {
        imports =
          [
            ./hardware-configuration.nix
            ../bootstrap/configuration.nix
          ];
      };
    };
  };
}

