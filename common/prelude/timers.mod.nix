{ config, lib, pkgs, ... }:
with lib; with builtins; {
  options = {
    my.timers = mkOption {
      type = let
        item = types.submodule {
         options = {
           trigger = mkOption { type = types.str; default = "minutely"; };
           script = mkOption { type = types.str; };
           user = mkOption { type = types.str; default = "${config.owner}"; };
           group = mkOption { type = types.str; default = "${config.owner}"; };
           path = mkOption { type = types.listOf types.package; };
         };
        };
      in types.attrsOf item;
      default = {};
    };
  };

  config = {
    systemd = let
      ys = attrValues (mapAttrs (name: x: {
        timers.${name} = {
          wantedBy = [ "multi-user.target" ];
          partOf = [ "${name}.service" ];
          #wants = [ "network.target" "network-online.target" ];
          #after = [ "network-online.target" ];
          timerConfig = {
            Unit = "${name}.service";
            OnCalendar = x.trigger;
          };
        };
        services.${name} = {
          serviceConfig = {
            Type = "oneshot";
            User = x.user;
            Group = x.group;
          };
          script = x.script;
          path = x.path;
        };
      }) config.my.timers);
    in {
      timers = foldl' (r: a: r // a.timers) {} ys;
      services = foldl' (r: a: r // a.services) {} ys;
    };
  };

}
