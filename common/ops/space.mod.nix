{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      parted #分区工具
      ncdu # TUI 可视化磁盘占用分析

      # gui sys tool
      gparted #可视化分区工具
      snapper-gui # btrfs 快照管理
    ];
  };
}
