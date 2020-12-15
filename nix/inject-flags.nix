# Inject build flags

{ pkgs ? import <unstable> { }
, name ? "entr"
, debug ? false
, flags ? "CFLAGS='-Werror'"
, lib ? import ./lib.nix { inherit debug; }
}:

lib.trace ("inject-flags ${flags} ${name}") (import ./instrument.nix {
  inherit debug pkgs;
  drv = pkgs.${name};
  blightEnv = ''
    export BLIGHT_ACTIONS=InjectFlags
    echo ${flags}
    export BLIGHT_ACTION_INJECTFLAGS="${flags}"
  '';
})
