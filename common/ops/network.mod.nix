{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      dnsutils #各种域名解析工具合集，包括dig等
      mtr #my traceroute 网络诊断工具

      # gui sys tool
      mtr-gui #my traceroute 网络诊断工具
    ];

  };
}
