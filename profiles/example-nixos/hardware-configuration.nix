/*

to generate hardware config:

$ sudo nixos-generate-config

or

$ sudo nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix

*/
{...}: {
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };
}
