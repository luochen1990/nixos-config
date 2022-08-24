{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    gnome-network-displays
    # xdg-desktop-portal
    # xdg-desktop-portal-gnome
    # xdg-desktop-portal-kde
  ];

  # TODO: not working yet, don't know why
  xdg.portal.enable = true;

  networking.firewall.allowedTCPPorts = [ 7236 7250 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
