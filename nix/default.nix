{ pkgs ? import <pkgs> { }
, name ? "entr"
, debug ? false
}:

let lib = import ./lib.nix { inherit debug; };
in {
  makefile = import ./extract-makefile.nix {
    inherit (pkgs) stdenv;
    inherit debug;
    drv = pkgs.${name};
  };
  cmakelists = import ./extract-cmakelists.nix {
    inherit (pkgs) stdenv;
    inherit debug;
    drv = pkgs.${name};
  };

  # Generic Blight instrumentation, records by default.
  instrument = import ./instrument.nix {
    inherit debug;
    drv = pkgs.${name};
  };
}
