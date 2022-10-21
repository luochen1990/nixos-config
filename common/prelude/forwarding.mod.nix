#Ref: https://github.com/X01A/nixos/blob/master/modules/services/forwarding/default.nix
{ config, pkgs, lib, ... }: with lib;
{
  options = {
    my.services.forwarding = {
      enable = mkOption { default = false; type = types.bool; };
      rules = mkOption {
        type = let
          rule = types.submodule {
           options = with lib; {
             type = mkOption { type = types.enum [ "tcp" "udp" ]; };
             port = mkOption { type = types.port; };
             target = mkOption { type = types.str; };
             targetPort = mkOption { type = types.port; };
             openFirewall = mkOption { type = types.bool; default = false; };
           };
          };
        in types.listOf rule;
      };
    };
  };

  config = let
    cfg = config.my.services.forwarding;

  in mkIf cfg.enable {
    systemd.services = builtins.listToAttrs (map (item: {
      name = "forwarding-${item.type}-${toString item.port}";
      value = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Port forwarding for ${item.type} protocol and port ${toString item.port}";
        serviceConfig = let
          proto = if item.type == "tcp" then "TCP4" else "UDP";
        in {
          ExecStart = "${pkgs.socat}/bin/socat ${proto}-LISTEN:${toString item.port},reuseaddr,fork ${proto}:${item.target}:${toString item.targetPort}";
          Restart = "always";
        };
      };
    }) cfg.rules);

    networking.firewall.allowedTCPPorts = map (x: x.port) (builtins.filter (x: x.type == "tcp" && x.openFirewall) cfg.rules);
    networking.firewall.allowedUDPPorts = map (x: x.port) (builtins.filter (x: x.type == "udp" && x.openFirewall) cfg.rules);
  };
}
