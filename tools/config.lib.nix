{ lib }:
let
  inherit (builtins) foldl' map attrNames;
  unionFor = ks: f: foldl' (a: b: a // b) {} (map f ks);
in
{
  # lib.mkDefault = lib.mkOverride 1000;
  mkDefault = lib.mkOverride 900;
  # the default priority level is 100
  mkForce = lib.mkOverride 90;
  # lib.mkForce = lib.mkOverride 50;

  mkSpecialisation = config: specialisation: unionFor (attrNames specialisation) (spid: {"${spid}" =
  let sp = specialisation.${spid}; in lib.mkMerge [sp {
    configuration = {
      system.nixos.tags = [ spid ];
      #DOC: https://github.com/viperML/nh?tab=readme-ov-file#specialisations-support
      environment.etc."specialisation".text = spid;

    } // (if (sp ? inheritParentConfig) && (sp.inheritParentConfig == false) then {
      # # for minimal specialisation
      inherit (config) owner wanInterfaces usageScenario;
      system.stateVersion = lib.mkDefault config.system.stateVersion;
      imports = [
        ../bedrock
        ../modules
        ({config, ...}: { _module.args.bedrock = config.stone-os; })
      ];
    } else {});
  }];});

  mkCalcOption = attrs: lib.mkOption (attrs // {
    internal = true;
    readOnly = true;
    visible = false;
  });
}
