{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      ethtool #以太网有线网卡信息查询和设置
      nftables # nft 等 iptables 规则管理工具
      dnsutils #各种域名解析工具合集，包括dig等
      mtr # mtr, mtr-packet; my traceroute 网络诊断工具

      # gui sys tool
      #mtr-gui # mtr, mtr-packet; my traceroute 网络诊断工具 (会覆盖TUI版本)
    ];

  };
}
