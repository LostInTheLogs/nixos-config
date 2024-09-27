{
  mylib,
  lib,
  ...
}: (lib.genAttrs (mylib.fs.getDirs ./.) mylib.mkHost)
