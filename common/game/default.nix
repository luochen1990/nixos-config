{ ... }: 
{
  imports = with builtins; let
    dirContents = readDir ./.;
    modNames = filter (name: match ".*\\.mod.nix" name != null) (attrNames dirContents);
  in map (name: ./. + "/${name}") modNames;
}
