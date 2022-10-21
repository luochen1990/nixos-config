{ config, pkgs, lib, ... }: 
{
  config = {

    # Ref: https://nixos.wiki/wiki/NixOps/Virtualization

    boot.kernelModules = [
      #"kvm-amd"
      "kvm-intel"
    ];
    virtualisation.libvirtd.enable = true;


    # Ref: https://nixos.wiki/wiki/Virt-manager

    environment.systemPackages = with pkgs; [
      virt-manager
      #virt-manager-qt
    ];

    users.users.${config.owner}.extraGroups = lib.mkIf config.virtualisation.libvirtd.enable [ "libvirtd" ];
  };
}
