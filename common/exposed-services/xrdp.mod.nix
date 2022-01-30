{ config, pkgs, lib, ... }: 
{
  config = {
    # Enable Remote Desktop daemon.
    # Ref: https://nixos.wiki/wiki/Remote_Desktop
    # Troubleshooting: https://discourse.nixos.org/t/please-post-working-xrdp-setting-in-configuration-nix/7404/8
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";
    #services.xrdp.defaultWindowManager = "startplasma-x11";
    networking.firewall.allowedTCPPorts = [ 3389 ];
  };
}
