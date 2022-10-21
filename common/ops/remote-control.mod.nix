{ config, pkgs, lib, ... }: 
{
  # about the ssh client
  #programs.ssh.startAgent = true; #NOTE: conflict with gpg agent

  config = lib.mkIf (config.gui.enable) {
    environment.systemPackages = with pkgs; [
      remmina # RDP/VNC client
    ];
  };
}
