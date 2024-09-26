# the tool functions which is frequently used but not contained in nixpkgs.lib
let
  inherit (builtins) filter map readDir attrNames match concatMap elem;
in rec {

  # isHidden : Path -> Bool
  isHidden = (path: match "\\..*" path != null);

  # isNotHidden : Path -> Bool
  isNotHidden = (path: match "\\..*" path == null);

  # hasPostfix : String -> Path -> Bool
  hasPostfix = postfix: path: match (".*\\." + postfix) path != null;

  # list all sub directories including hidden ones
  # subDirsAll : Path -> [Path]
  subDirsAll = (path: let d = readDir path; in filter (k: d.${k} == "directory") (attrNames d));

  # subDirs : Path -> [Path]
  subDirs = (path: let d = readDir path; in filter (k: d.${k} == "directory" && (isNotHidden k)) (attrNames d));

  # subDirsRec : Path -> ({depth: Int, abspath: Path, relpath: Path} -> Bool) -> [Path]
  subDirsRec = root: test:
  let recur = root: test: depth: concatMap (relpath:
    let abspath = "${root}/${relpath}";
    in (if test {inherit depth abspath relpath;} then [relpath] else []) ++ map (s: "${relpath}/${s}") (recur abspath test (depth + 1))
  ) (subDirsAll root);
  in recur root test 0;

  # findFiles : Path -> String -> [Path]
  findFiles = root: postfix: let fs = filter (name: match (".*\\." + postfix) name != null) (attrNames (readDir root)); in map (fname: root + "/${fname}") fs;

  # findFilesRec : Path -> ({depth: Int, absdir: Path, reldir: Path} -> Bool)
  #                     -> ({depth: Int, absdir: Path, reldir: Path, filename: String} -> Bool)
  #                     -> [Path]
  findFilesRec = root: dirTest: fileTest:
  let recur = depth: reldir:
    let
      absdir = "${root}/${reldir}";
      entries = readDir absdir;
      files = filter (name: entries.${name} == "regular") (attrNames entries);
      subdirs = filter (name: entries.${name} == "directory") (attrNames entries);
    in
      concatMap (filename:
        if fileTest { inherit depth absdir reldir filename; }
        then [{inherit reldir absdir filename;}] else []
      ) files ++
      concatMap (subdir:
        let reldir' = if reldir == "" then subdir else "${reldir}/${subdir}";
        in if dirTest { inherit depth absdir reldir; } then recur (depth + 1) reldir' else []
      ) subdirs;
  in recur 0 "";

  # dirContainsFile : Path -> String -> Bool
  dirContainsFile = dir: filename: elem filename (attrNames (readDir dir));

  # findSubDirsContains : Path -> String -> [Path]
  findSubDirsContains = root: filename:
  concatMap (dir:
    let p = "${root}/${dir}";
    in (if dirContainsFile p filename then [dir] else []) ++ map (s: "${dir}/${s}") (findSubDirsContains p filename)
  ) (subDirsAll root);

}
