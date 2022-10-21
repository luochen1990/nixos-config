{ pkgs, lib, system, nixos-cn, ... }: 
{
  # required gui software
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "padekgcemlokbadohgkifijomclgjgif" # proxy-switchyomega
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
  ];

  environment.variables = {
    #QT_IM_MODULE = lib.mkForce "ibus"; # workaround for fcitx5 & qt6
  };

  environment.sessionVariables = {
    # These is a hack for chromium, and these key is from public web
    GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
    GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
  };

  ## workaround for obsidian
  #nixpkgs.config.permittedInsecurePackages = [
  #  "electron-13.6.9"
  #];

  environment.systemPackages = with pkgs; [
    # daily tui software
    httpie
    unar # extract from rar file, free software replacement of unrar
    unzip # extract from zip file
    p7zip # support of 7z format, see 7-zip.org

    # daily gui software

    chromium # open source Chrome impl
    tdesktop # official client of the IM telegram
    element-desktop # client of matrix IM
    #discord # voice and text chat
    thunderbird # full-featured e-mail client

    nixos-cn.legacyPackages.${system}.wine-wechat
    #nixos-cn.wine-wechat
    #nixos-cn.wechat-uos
    #nixos-cn.netease-cloud-music

    fsearch # search files like 'everything on windows'
    #spectacle #屏幕截图工具
    flameshot #屏幕截图工具
    crow-translate #dict, 翻译，带OCR功能
    qrencode # 二维码生成 provide qrencode command

    logseq #笔记软件, 开源 & 双向链接 & 数据本地存储
    #obsidian #笔记软件, 开源 & 双向链接 & 数据本地存储

    synergy #鼠标键盘多机器同步
    wakatime #时间统计

    rclone #network drive sync tool
    rclone-browser  # gui client for rclone
  ];
}
