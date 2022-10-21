{ config, pkgs, lib, ... }: 
{
  environment.systemPackages = with pkgs; [
    radare2 # radare2
    pax-utils # dumpelf, lddtree, symtree, scanelf, pspax, scanmacho
  ];
}
