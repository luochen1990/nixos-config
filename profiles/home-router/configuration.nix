# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/prelude
  ];

  config = {
    # 默认网卡
    mainInterface = "enp2s0";

    # 默认用户
    owner = "lc";

    system.stateVersion = "22.11";
  };
}

