#Ref: https://github.com/NickCao/flakes/blob/d1540b840c97bce35ec01d4ee895cb344e49e8b7/nixos/local/configuration.nix#L167-L189
#Ref: https://github.com/NickCao/flakes/blob/master/pkgs/smartdns-china-list/default.nix

{ config, lib, pkgs, ... }:

let smartdns-china-list = pkgs.stdenv.mkDerivation {
  pname = "smartdns-china-list";
  version = "e880dde91e5677ad1db600224127a50fdbff77da";
  src = pkgs.fetchFromGitHub ({
    owner = "felixonmars";
    repo = "dnsmasq-china-list";
    rev = "e880dde91e5677ad1db600224127a50fdbff77da";
    fetchSubmodules = false;
    sha256 = "sha256-6iFkTbWgnSxKNnth7Lv988zCOpHKhyKbnLh4dQJk8H8=";
  });
  buildPhase = ''
    make smartdns SERVER=china
  '';
  installPhase = ''
    install -Dm644 "accelerated-domains.china.smartdns.conf" "$out/accelerated-domains.china.smartdns.conf"
    install -Dm644 "apple.china.smartdns.conf" "$out/apple.china.smartdns.conf"
    install -Dm644 "google.china.smartdns.conf" "$out/google.china.smartdns.conf"
  '';
}; in
{
  services.smartdns.enable = true;
  services.smartdns.bindPort = 53;
  services.smartdns.settings = {
    cache-size = 65536;
    prefetch-domain = true;
    log-level = "info";
    speed-check-mode = "tcp:443,tcp:80,ping";
    serve-expired = "yes";
    #audit-enable = "yes";
    conf-file = [
      "${smartdns-china-list}/accelerated-domains.china.smartdns.conf"
      "${smartdns-china-list}/apple.china.smartdns.conf"
      "${smartdns-china-list}/google.china.smartdns.conf"
    ];
    bind = [
      "127.0.0.1:53"
      "127.0.0.53:53"
    ];
    server-https = [
      "https://1.0.0.1/dns-query"
      "https://1.1.1.1/dns-query"
      "https://185.222.222.222/dns-query"
      "https://cloudflare-dns.com/dns-query -exclude-default-group"
    ];
    server-tls = [
      "8.8.8.8:853"
      "1.1.1.1:853"
    ];
    server = [
      "202.101.172.35 -group china -exclude-default-group"
      "202.101.172.47 -group china -exclude-default-group"
      "114.114.114.114 -group china -exclude-default-group"
      #"2a0c:b641:69c:7864:0:5:0:3"
    ];
  };

  networking.firewall.allowedTCPPorts = [ config.services.smartdns.bindPort ];
  networking.firewall.allowedUDPPorts = [ config.services.smartdns.bindPort ];
}
