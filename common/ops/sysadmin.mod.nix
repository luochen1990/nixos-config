{ config, pkgs, lib, ... }: 
{
  environment.systemPackages = with pkgs; [
    neofetch # 查看系统信息, 硬件配置, 内核版本等
    hardinfo # show hardware informations 查看系统硬件信息
    ventoy-bin # U盘启动盘制作工具, 装机工具

    #GUI
    qjournalctl # GUI log viewer
    #neovide # neovim gui client
  ];
}
