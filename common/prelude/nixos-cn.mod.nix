{ config, pkgs, lib, ... }: 
{
  config = {
    # 使用 nixos-cn 的 binary cache

    #nix.binaryCaches = [
    nix.settings.substituters = [
      "https://nixos-cn.cachix.org"
    ];
    #nix.binaryCachePublicKeys = [ "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg=" ];
    nix.settings.trusted-public-keys = [ "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg=" ];
  };
}
