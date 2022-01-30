{ config, pkgs, lib, ... }: 
{
  # about the ssh client
  #programs.ssh.startAgent = true; #NOTE: conflict with gpg agent

  environment.systemPackages = with pkgs; [
    # GUI tool
    remmina # RDP/VNC client
    synergy #鼠标键盘多机器同步
  ];
}
