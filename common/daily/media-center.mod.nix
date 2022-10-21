{ pkgs, ... }: 
{
  environment.systemPackages = [
    (pkgs.kodi.withPackages (kodiPackages: with kodiPackages; [
      pvr-iptvsimple
      #netflix
      youtube
      #svtplay
      #inputstream-adaptive
      #inputstreamhelper
    ])) #kodi with jiotv, last is for drm
  ];
}
