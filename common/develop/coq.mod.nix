{ config, pkgs, lib, ... }: 
{
  config = {
    #Ref: https://gist.github.com/luochen1990/68e5e38496b79790e70d82814bdfc69a

    services.emacs.enable = true;

    environment.systemPackages = with pkgs; [
      coq
      emacsPackages.proof-general
    ];
  };
}
