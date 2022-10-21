{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      lshw # 查看硬件信息，用法示例:  lshw -C network
      pciutils # lspci 查看设备
    ];
  };
}
