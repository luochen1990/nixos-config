{ config, pkgs, lib, ... }: 
{
  config = {
    # Enable virtualbox
    # Ref: https://nixos.wiki/wiki/Virtualbox
    #virtualisation.virtualbox.host.enable = true;
    #virtualisation.virtualbox.host.enableExtensionPack = true; //NOTE: this is unfree
    #users.extraGroups.vboxusers.members = [ config.owner ];

    environment.systemPackages = with pkgs; [
      #linuxPackages_latest.virtualboxGuestAdditions
    ];

  };
}
