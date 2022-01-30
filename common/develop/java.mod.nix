{ config, pkgs, lib, ... }: 
{
  config = {
    environment.systemPackages = with pkgs; [
      openjdk maven #adoptopenjdk-bin
    ];
    programs.java.enable = true;
  };
}
