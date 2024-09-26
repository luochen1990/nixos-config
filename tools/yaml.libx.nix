{ lib, pkgs }:
{
  # yaml.generate :: Path -> AttrSet -> Drv
  yaml.generate = (pkgs.formats.yaml {}).generate;

  # 定义一个工具函数来读取 YAML 文件并将其转换为 Nix 数据结构
  # yaml.readFile :: Path -> AttrSet
  yaml.readFile = yaml-filename:
  let
    yj = pkgs.yj;
    json-file = pkgs.runCommand "yaml-to-json" { buildInputs = [ yj ]; } ''
      yj -yj < ${yaml-filename} > $out
    '';
  in
    builtins.fromJSON (builtins.readFile json-file);
}
