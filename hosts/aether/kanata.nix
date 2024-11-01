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
          z (t! thold z lctl)
          x (t! thold x lmet)
          q (t! thold q lalt)
          w (t! thold w ralt)

          / (t! thold / lctl)
          . (t! thold . lmet)
          p (t! thold p lalt)
          o (t! thold o ralt)

          caps tab
          tab esc

          spc (t! thold spc (layer-while-held symbols) )
        )

        (deflayermap (symbols)
          q S-1
          w S-2
          e S-3
          r S-4
          t S-5

          y S-6
          u S-7
          i S-8
          o bspc
          p S-0

          a S-[
          s S-9
          d S-0
          f S-[
          g =

          h grv
          j S-'
          k '
          l S--
          ; \

          z S-grv
          x [
          c ]
          v -
          b S-=

          n S-\
          m m
          , S-,
          . S-.
          / \

        )
      '';
    };
  };
}
