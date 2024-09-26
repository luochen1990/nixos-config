# the tool functions which is frequently used but not contained in nixpkgs.lib
let
  inherit (builtins) map tail head concatLists length;
in rec {

  # for : [a] -> (a -> b) -> [b]
  for = xs: f: map f xs;

  # forWithIndex : [a] -> (Int -> a -> b) -> [b]
  forWithIndex = l: f: (builtins.foldl' ({i, l'}: x: {i = i+1; l' = l' ++ [(f i x)];}) {i=0; l'=[];} l).l';

  # forAttrs : Dict k v -> (k -> v -> a) -> [a]
  forAttrs = d: f: map (k: f k d.${k}) (builtins.attrNames d);

  # concatFor : [a] -> (a -> [b]) -> [b]
  concatFor = xs: f: concatLists (map f xs);

  # powerset : [a] -> [[a]]
  powerset = xs: if xs == [] then [[]] else let ps = powerset (tail xs); in ps ++ (map (ys: [(head xs)] ++ ys) ps);

  # cartesianProduct : [[a]] -> [[a]]
  cartesianProduct = lists:
  let
    tailProduct = cartesianProduct (builtins.tail lists);
  in
  if builtins.length lists == 0 then [[]]
  else builtins.concatMap (item: builtins.map (sublist: [item] ++ sublist) tailProduct) (builtins.head lists);

  # not-empty : [a] -> Bool
  not-empty = xs: length xs > 0;

  # is-empty : [a] -> Bool
  is-empty = xs: length xs == 0;

}
