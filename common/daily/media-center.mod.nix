{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    (kodi.withPackages (p: with p; [ inputstream-adaptive pvr-iptvsimple inputstreamhelper ])) #kodi with jiotv, last is for drm
  ];
}
