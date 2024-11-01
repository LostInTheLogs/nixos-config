{...}: {
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
          tap-timeout   90
          hold-timeout  180
          tt $tap-timeout
          ht $hold-timeout
        )

        (deftemplate thold (tap-action hold-action)
          (tap-hold $tt $ht $tap-action $hold-action)
        )

        (deflayermap (base)
          z (thold! z lctl)
          x (thold! x lmet)
          q (thold! q lalt)
          w (thold! w ralt)

          / (thold! / lctl)
          . (thold! . lmet)
          p (thold! p lalt)
          o (thold! o ralt)

          spc (!thold spc (layer-while-held symbols) )
        )

        (deflayermap (symbols)
          s \(
        )
      '';
    };
  };
}
