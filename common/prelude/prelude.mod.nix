# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, nixpkgs, ... }: 
{
  options = {
    profileName = lib.mkOption {
      type = lib.types.str;
      description = ''
        The directory name of profile. This will decide networking.hostName.
      '';
    };
    owner = lib.mkOption {
      type = lib.types.str;
      description = ''
        The user name of the owner of this system.
      '';
    };
    mainInterface = lib.mkOption {
      type = lib.types.str;
      description = ''
        The main network interface of this system.
      '';
    };
    debug.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable debug options
      '';
    };
    gui.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If `gui.enable == false` then GUI apps will not be installed.
      '';
    };
    gui.desktopEnvironment = lib.mkOption {
      type = lib.types.enum [ "kde" "gnome" null ];
      default = "kde";
      description = ''
        Which DE to use: kde-plasma or gnome
      '';
    };
    gui.displayServer = lib.mkOption {
      type = lib.types.enum [ "x11" "wayland" ];
      default = if config.gui.desktopEnvironment == "gnome" then "wayland" else "x11";
      description = ''
        Which Display Server to use: x11 or wayland
      '';
    };
    exposed.domain-name = lib.mkOption {
      type = lib.types.str;
      description = ''
        The exposed domain name of this host machine.
        (this decides configuration of exposed services like nginx etc.)
      '';
    };
    exposed.subdomain-root = lib.mkOption {
      type = lib.types.str;
      description = ''
        Root of the exposed sub-domain names of this host machine.
        (this decides configuration of exposed services like nginx etc.)
      '';
    };
    exposed.port = lib.mkOption {
      type = lib.types.port;
      description = ''
        The exposed port of this host machine.
        (this decides configuration of exposed services like nginx etc.)
      '';
    };
  };

  config = {
    # Boot
    boot.loader.grub = {
      enable = true;
      #useOSProber = true;
      device = lib.mkDefault "nodev";
      efiSupport = lib.mkDefault true;
      efiInstallAsRemovable = lib.mkDefault true;
      splashImage = lib.mkForce ../resources/nixos-neofetch-ascii-wallpaper.png;
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry 'System setup' {
         fwsetup
        }
      '';
    };
    #boot.loader.efi.canTouchEfiVariables = true;
    #boot.supportedFilesystems = [ "ntfs" ];

    # Kernel: enable Zen to optmize performance
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

    # Network
    networking.hostName = config.profileName;
    networking.enableIPv6 = lib.mkDefault false;

    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false; # workaround for issue: https://mail.gnome.org/archives/networkmanager-list/2018-June/msg00008.html
    #networking.networkmanager.unmanaged = builtins.attrNames config.networking.wireless.networks;
    networking.networkmanager.unmanaged = builtins.attrNames config.networking.wireguard.interfaces;

    networking.wireless.enable = (config.networking.wireless.networks != {});  # Enables wireless support via wpa_supplicant.
    networking.wireless.userControlled.enable = !config.networking.networkmanager.enable;

    # Firewall
    networking.firewall.enable = lib.mkDefault true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,[::1],localhost,internal.domain";

    console = {
      font = lib.mkOverride 999 "Lat2-Terminus16";
      keyMap = lib.mkDefault "us";
      useXkbConfig = lib.mkDefault config.gui.enable;
    };

    nixpkgs.config.allowUnfree = true;

    # users that have additional rights when connecting to the Nix daemon
    nix.settings.trusted-users = [ "root" config.owner ];

    # make nix version keep sync with nixos
    nix.settings.nix-path = [ "nixpkgs=${nixpkgs}" ];

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

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

    # Power saving
    #DOC: https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.nvidia.powerManagement.enable = lib.mkDefault false; # Experimental power management, see the NVIDIA docs, on Chapter 21.

    # HiDPI Display
    hardware.video.hidpi.enable = lib.mkDefault true;
    #services.xserver.dpi = 180; # for 4K monitor

    # Enable sound.
    # Volume Control: $ alsamixer
    # test: speaker-test -c 2
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Enable Bluetooth support.
    hardware.bluetooth.enable = true;

    # Enable touchpad support.
    #services.xserver.libinput.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = lib.mkDefault false;
    services.printing.drivers = []; #DOC: https://nixos.wiki/wiki/Printing

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.owner} = {
      isNormalUser = true;
      group = "${config.owner}";
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
    };

    users.groups.${config.owner} = {
      gid = 1000;
      name = config.owner;
      members = [ config.owner ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # sys tool
      #neovim
      #wget
      #git git-crypt gnupg pinentry pinentry-qt icdiff
      #zsh antigen
      #fzf
      #tmux 
      #sqlite 
      xclip
      fd #文件名/目录名 搜索
      tldr #帮助文档, 更简单的 man
      file #查看文件信息
      tree #树状展示文件目录结构
      #nm-tray #Network Manager frontend (tray icon?) written in Qt
    ];

  };

  imports = [
    # GUI Desktop Environment

    { services.xserver.enable = config.gui.enable; }

    { config = lib.mkIf (config.gui.enable && config.gui.desktopEnvironment == "gnome") {
      services.xserver = {
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = (config.gui.displayServer == "wayland");
        desktopManager.gnome.enable = true;
        desktopManager.gnome.debug = config.debug.enable;
      };
    }; }

    { config = lib.mkIf (config.gui.enable && config.gui.desktopEnvironment == "kde") {
      services.xserver = {
        desktopManager.plasma5.enable = true;
        desktopManager.plasma5.useQtScaling = true; #Enable HiDPI scaling in Qt. seems no obvious effect
      };
    }; }

    { config = lib.mkIf (config.gui.enable) {
      i18n.inputMethod.enabled = "ibus";
      i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ rime ];

      #i18n.inputMethod.enabled = "fcitx";
      #i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime ];

      #i18n.inputMethod.enabled = "fcitx5";
      #i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons ];
    }; }

  ];

}
