{ config, pkgs, lib, ... }: 
{
  imports = [
    ./java.mod.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      #scala.override { jre = pkgs.jdk11; } 
      scala sbt
    ];
  };
}
