# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }: 
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      '';
  };

  nix.binaryCaches = [
    "https://mirrors.bfsu.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
  ];

  environment.systemPackages = with pkgs; [
  # sys tool
    wget
    neovim xclip
    git git-crypt gnupg pinentry pinentry-qt
    icdiff # 文本diff
    zsh antigen fzf sqlite 
    ripgrep # rg 文本搜索，grep / ag 的替代品
    fd # 文件名搜索
    tldr # man / cheat 的替代品
    file # 查看文件信息
    tree # 树状展示文件目录结构
    mtr # 网络诊断工具 my traceroute
    #ntfs3g # 微软NTFS文件系统支持
    #proxychains

  # gui sys tool
    gpa #pgp密钥管理
    gparted #可视化分区工具
    mtr-gui # 网络诊断工具 my traceroute GUI
    hardinfo # show hardware informations 查看系统硬件信息

  # required gui software
    google-chrome

  # daily gui software
    spectacle #屏幕截图工具
    #crow-translate #翻译，带OCR功能
    tdesktop # the telegram desktop client
  ];

  environment.interactiveShellInit = ''
    alias vi=nvim
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Create user as you need
  # users.users.lc = {
  #   isNormalUser = true;
  #   extraGroups = [
  #     "wheel" # Enable ‘sudo’ for the user.
  #   ];
  #   shell = pkgs.zsh;
  # };
}
