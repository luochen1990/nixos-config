# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, nixpkgs, packages, ... }: 
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
    tuning.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        是否启用一些微妙的优化点，如果遇到问题要排查可以选择关闭这一项以减少干扰
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
    boot.loader.timeout = lib.mkOverride 999 10; #in seconds
    boot.loader.grub = {
      enable = lib.mkOverride 999 true;
      #useOSProber = lib.mkOverride 999 true;
      device = lib.mkOverride 999 "nodev";
      efiSupport = lib.mkOverride 999 true;
      efiInstallAsRemovable = lib.mkOverride 999 true;
      splashImage = lib.mkOverride 999 ../resources/nixos-neofetch-ascii-wallpaper.png;
      extraEntries = lib.mkOverride 999 ''
        menuentry "Reboot (r)" --hotkey r --class restart {
          reboot
        }
        menuentry "Power Off" --class shutdown {
          halt
        }
        menuentry 'Firmware Setup (s)' --hotkey s --class settings {
          fwsetup
        }
        menuentry 'Help (h)' --hotkey h --class help {
          echo 'See following web page for more available commands:'
          echo ' https://www.gnu.org/software/grub/manual/grub/html_node/Command_002dline-and-menu-entry-commands.html'
          echo '... press any key to continue ...'
          read
          help
        }
        submenu "... More (m) ..." --hotkey m --class submenu {
          menuentry "Go Back" --class cancel {
            echo "To go up, press ESC ..."
            #sendkey escape
            sleep 3
          }
          menuentry "Memtest86" --class memtest {
            echo 'keyboard & mouse might not available on some machine, just poweroff if this occurs ...'
            echo 'press any key to continue ...'
            read
            chainloader /memtest86.efi
          }
          menuentry "Windows" --class windows {
            insmod part_gpt
            insmod fat
            insmod chain
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        }
      '';
      extraFiles = {
        "memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
      };
    };
    boot.loader.grub.theme = "${packages.sleek-grub-theme}";
    #boot.loader.grub.memtest86.enable = true;
    #boot.loader.efi.canTouchEfiVariables = true;
    #boot.supportedFilesystems = [ "ntfs" ];

    # Kernel: enable Zen to optmize performance
    boot.kernelPackages = lib.mkOverride 999 pkgs.linuxPackages_zen;

    # Network
    networking.hostName = config.profileName;
    networking.enableIPv6 = lib.mkOverride 999 false;

    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false; # workaround for issue: https://mail.gnome.org/archives/networkmanager-list/2018-June/msg00008.html
    #networking.networkmanager.unmanaged = builtins.attrNames config.networking.wireless.networks;
    networking.networkmanager.unmanaged = builtins.attrNames config.networking.wireguard.interfaces;

    networking.wireless.enable = (config.networking.wireless.networks != {});  # Enables wireless support via wpa_supplicant.
    networking.wireless.userControlled.enable = !config.networking.networkmanager.enable;

    # Firewall
    networking.firewall.enable = lib.mkOverride 999 true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,[::1],localhost,internal.domain";

    console = {
      font = lib.mkOverride 999 "Lat2-Terminus16";
      keyMap = lib.mkOverride 999 "us";
      useXkbConfig = lib.mkOverride 999 config.gui.enable;
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
      #package = pkgs.nixFlakes;
      package = pkgs.nixVersions.stable;
      extraOptions = ''
          experimental-features = nix-command flakes
      '';
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

    # Power saving
    #DOC: https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt
    powerManagement.cpuFreqGovernor = lib.mkOverride 999 "powersave";
    hardware.nvidia.powerManagement.enable = lib.mkOverride 999 false; # Experimental power management, see the NVIDIA docs, on Chapter 21.

    # HiDPI Display
    hardware.video.hidpi.enable = lib.mkOverride 999 true;
    #services.xserver.dpi = 180; # for 4K monitor

    # DDC/CI control display/monitor via software
    services.ddccontrol.enable = true;

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
    services.printing.enable = lib.mkOverride 999 false;
    services.printing.drivers = []; #DOC: https://nixos.wiki/wiki/Printing

    # tuning journaldctl
    # Doc: https://helpmanual.io/man5/journald.conf/
    # Use `Storage=volatile` to keep logs only in memory
    # Note that `MaxLevelStore=notice` makes info log invisiable
    services.journald.extraConfig = ''
      Storage=volatile
      ForwardToSyslog=true

      RateLimitInterval=15min
      RateLimitBurst=1000

      SystemMaxUse=500M
      SystemMaxFileSize=10M
      RuntimeMaxUse=500M
      RuntimeMaxFileSize=10M
    '';

    # use syslog to persistant important logs
    services.rsyslogd.enable = true;

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
