# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }: 
{
  options = {
    owner = lib.mkOption {
      type = lib.types.str;
      description = ''
        The user name of the owner of this system.
      '';
    };
    profileName = lib.mkOption {
      type = lib.types.str;
      description = ''
        The directory name of profile. This will decide networking.hostName.
      '';
    };
    hasGUI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If `hasGUI == false` then GUI apps will not be installed.
      '';
    };
  };

  config = {
    boot.loader.grub = {
      enable = true;
      #useOSProber = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
      splashImage = ../resources/nixos-neofetch-ascii-wallpaper.png;
    };
    #boot.loader.efi.canTouchEfiVariables = true;
    #boot.supportedFilesystems = [ "ntfs" ];
 
    # Enable Zen kernel to optmize performance
    boot.kernelPackages = pkgs.linuxPackages_zen;

    networking.hostName = config.profileName;
    networking.wireless = {
      enable = true;  # Enables wireless support via wpa_supplicant.
      userControlled.enable = true;
    };
    networking.enableIPv6 = lib.mkDefault false;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    #networking.useDHCP = false;
    #networking.interfaces.enp2s0.useDHCP = true;

    hardware.video.hidpi.enable = true;
    #services.xserver.dpi = 180;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    #i18n.inputMethod.enabled = "ibus";
    #i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ rime ];

    i18n.inputMethod.enabled = "fcitx";
    i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime ];

    fonts = {
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        source-code-pro
        wqy_microhei
        wqy_zenhei
      ];
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
      #useXkbConfig = true;
    };

    nixpkgs.config.allowUnfree = true;

    # automatic run `nix-store --optimise` everyday
    nix.optimise.automatic = true;
    # nix.optimise.dates = [ "03:45" ]

    # enable nix flakes
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
          experimental-features = nix-command flakes
      '';
    };

    # Enable the firewall.
    networking.firewall.enable = lib.mkDefault true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.layout = "us";

    # Enable the KDE Desktop Environment.
    services.xserver.displayManager.sddm.enable = true; #NOTE: disable sddm to use lightdm if there is any issure about login
    services.xserver.desktopManager.plasma5.enable = true;
    #services.xserver.desktopManager.plasma5.useQtScaling = true; #Enable HiDPI scaling in Qt. seems no obvious effect

    # Enable sound.
    # Volume Control: $ alsamixer
    # test: speaker-test -c 2
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Enable Bluetooth support.
    hardware.bluetooth.enable = true;

    # Enable touchpad support.
    # services.xserver.libinput.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.owner} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # sys tool
      wget neovim
      git git-crypt gnupg pinentry pinentry-qt icdiff
      zsh antigen
      fzf
      tmux 
      sqlite 
      xclip
      neofetch # 查看系统信息, 硬件配置, 内核版本等
      ripgrep ag #文本搜索，grep的替代品
      fd # 文件名/目录名 搜索
      tldr # 帮助文档, 更简单的 man
      file #查看文件信息
      tree #树状展示文件目录结构

      # gui sys tool
      gparted #可视化分区工具
      mtr-gui #my traceroute 网络诊断工具
      fsearch # search files like 'everything on windows'
      hardinfo # show hardware informations 查看系统硬件信息
      qjournalctl # GUI log viewer

      # required gui software
      google-chrome

      # daily gui software
      spectacle #屏幕截图工具
      remmina
      okular #pdf文档查看
      tdesktop # the telegram desktop client
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "20.03"; # Did you read the comment?

  };
}
