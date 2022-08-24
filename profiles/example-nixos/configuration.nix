# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }: 
{
  imports = [
    ./hardware-configuration.nix
    ../../common/prelude
    ../../common/daily
    ../../common/ops
    ../../common/virtualize
    ../../common/develop
    ../../common/study
  ];

  owner = "lc";
  mainInterface = "eth0";

  specialisation = {
    hidpi = {
      configuration = {
        hardware.video.hidpi.enable = true;
        services.xserver.dpi = 180;
      };
    };
    minimal = {
      inheritParentConfig = false;
      configuration = {
        imports = [
          ./hardware-configuration.nix
          ../../common/prelude
          ../../common/daily
          ../../common/ops
        ];
        profileName = config.profileName;
        owner = config.owner;
      };
    };
  };

  system.stateVersion = "22.11";
}

