{mylib, ...}:
# generate modules with imports containing every file in this directory. I don't like manual importing
{
  default = {...}: {imports = mylib.fs.getNixFilesButRec ./. ./default.nix;};
}
