{lib, ...}: let
  inherit (lib) pipe flatten mapAttrsToList filter filterAttrs hasSuffix;
  inherit (builtins) readDir attrNames;
in rec {
  getDirs = dir:
    pipe dir [
      readDir
      (filterAttrs (_: type: type == "directory"))
      attrNames
    ];

  getFilesRec = dir:
    flatten (
      mapAttrsToList
      (file: type:
        if type == "directory"
        then getFilesRec /.${dir}/${file}
        else /.${dir}/${file})
      (readDir dir)
    );

  getNixFilesRec = dir:
    filter (path: hasSuffix ".nix" path) (getFilesRec dir);

  getNixFilesButRec = dir: exception:
    filter (path: path != exception) (getNixFilesRec dir);
}
