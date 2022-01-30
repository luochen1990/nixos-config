{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      htop #better top
      nmap #端口扫描,网络工具
      pstree #树状展示进程父子关系

      # GUI tools
      qjournalctl # GUI log viewer
    ];
  };
}
