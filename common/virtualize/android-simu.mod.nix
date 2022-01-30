{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      # genymotion # an android mobile device simulator, which not works now
    ];

  };
}
