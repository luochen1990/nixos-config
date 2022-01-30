{ config, pkgs, lib, ... }: 
{
  imports = [
    ./c.mod.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      stack haskell-language-server
    ];

    #services.hoogle = {
    #  enable = true;
    #  port = 78080; # default is 8080
    #}

  };
}
