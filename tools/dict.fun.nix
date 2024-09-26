# the tool functions which is frequently used but not contained in nixpkgs.lib
let
  inherit (builtins) foldl' map listToAttrs;
in {

  # dict : [k] -> (k -> v) -> Dict k v
  #  or lib.genAttrs
  dict = ks: f: listToAttrs (map (k: {name = k; value = f k;}) ks);

  # dict' : [k] -> (k -> k') -> (k -> v) -> Dict k' v
  dict' = ks: fk: fv: listToAttrs (map (k: {name = fk k; value = fv k;}) ks);

  # unionFor : [a] -> (a -> Dict k v) -> Dict k v
  #  similar to foldMap in Haskell
  unionFor = ks: f: foldl' (a: b: a // b) {} (map f ks);

}
