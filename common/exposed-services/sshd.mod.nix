{ config, pkgs, lib, ... }: 
{
  config = {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
