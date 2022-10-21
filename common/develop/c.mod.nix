{ config, pkgs, lib, ... }: 
{
  options = {
    develop.c.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether need c develop environment
      '';
    };
    develop.c.toolchain = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether need c toolchain to build from source code
      '';
    };
    develop.c.debug = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether need c debug tools to debug c programs
      '';
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      gcc gnumake
      gdb
    ];
  };
}
