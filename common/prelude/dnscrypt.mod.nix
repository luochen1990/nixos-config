{ config, lib, pkgs, ... }:

{
  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    resolvconf.useLocalResolver = true;
    dhcpcd.extraConfig = lib.mkIf config.networking.dhcpcd.enable "nohook resolv.conf";
    networkmanager.dns = lib.mkIf config.networking.networkmanager.enable "none";
  };

  services.dnscrypt-proxy2 = {
     enable = true;
     settings = {
       # Ref: https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml

       cache = true;
       cache_size = 4096;
       cache_min_ttl = 14400; # in seconds

       block_ipv6 = !config.networking.enableIPv6;
       ipv6_servers = config.networking.enableIPv6;

       sources.public-resolvers = {
         urls = [
           "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
           "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
         ];
         cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
         minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
         refresh_delay = 72;
       };

       require_dnssec = true;
       require_nolog = true;
       require_nofilter = true;

       # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
       #server_names = ['scaleway-fr', 'google', 'yandex', 'cloudflare']
     };
   };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
}
