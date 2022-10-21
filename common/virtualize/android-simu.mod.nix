{ config, pkgs, lib, ... }: 
{
  imports = [
    { config = lib.mkIf (config.gui.displayServer == "wayland") {
      virtualisation.waydroid.enable = true;  # need dns port
    }; }

    { config = lib.mkIf (config.gui.displayServer == "x11") {
      environment.systemPackages = with pkgs; [
        #anbox # don't know how to use
        #genymotion # an android mobile device simulator, which not works now
      ];
    }; }

  ];
}
