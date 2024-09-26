# .fun.nix 文件属于基础部分，不依赖 lib 因此也不需要初始化
# .lib.nix 文件依赖 nixpkgs.lib 因此需要初始化
let
  inherit (import ./file.fun.nix) findFiles;
  inherit (import ./dict.fun.nix) unionFor;
  useLib = lib: {
    usePkgs = pkgs: unionFor (findFiles ./. "libx.nix") (fname: import fname { inherit lib pkgs; });
  } // unionFor (findFiles ./. "lib.nix") (fname: import fname { inherit lib; });
in
  { inherit useLib; } // unionFor (findFiles ./. "fun.nix") import
