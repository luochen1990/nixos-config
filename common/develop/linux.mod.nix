{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      patchelf
      bintools-unwrapped
    ];
  };
}
