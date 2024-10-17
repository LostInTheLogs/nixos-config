{
  lib,
  config,
  ...
}: let
  cfg = config.kanata;
in {
  options.kanata.enable = lib.mkEnableOption "kanata";

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        "laptop".config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
                                    spc
          )

          (defvar
            tap-timeout   100
            hold-timeout  180
            tt $tap-timeout
            ht $hold-timeout
          )

          (defalias
            z(tap-hold $tt $ht z lctl)
            x(tap-hold $tt $ht x lmet)
            q(tap-hold $tt $ht q lalt)
            w(tap-hold $tt $ht w ralt)

            /(tap-hold $tt $ht / lctl)
            .(tap-hold $tt $ht . lmet)
            l(tap-hold $tt $ht l lalt)
            o(tap-hold $tt $ht o ralt)
          )

          (deflayer base
            grv   1    2    3    4    5    6    7    8    9    0    -    =    bspc
            esc   q    w    f    p    g    j    l    u    y    ;    [    ]    \
            tab   a    r    s    t    d    h    n    e    i    o    '    ret
            lsft  @z   x    c    v    b    k    m    ,    .    /    rsft
                                    spc
          )
        '';
      };
    };
  };
}
