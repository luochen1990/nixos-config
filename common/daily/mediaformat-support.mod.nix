{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    zathura #pdf文档查看
    #okular #pdf文档查看
    libreoffice # opensource office (doc view/edit)
    digikam # photo/picture manager
    kmplayer # vedio
  ];
}
