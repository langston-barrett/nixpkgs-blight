# Create LLVM bitcode with GLLVM

{ pkgs ? import <unstable> { }
, name ? "entr"
, debug ? false
, lib ? import ./lib.nix { inherit debug; }
}:

lib.trace ("bitcode ${name}") (import ./instrument.nix {
  inherit debug pkgs;
  drv = pkgs.${name};
  stdenv = pkgs.clangStdenv;
  blightEnv = ''
    export BLIGHT_WRAPPED_CC=${pkgs.gllvm}/bin/gclang
    export BLIGHT_WRAPPED_CXX=${pkgs.gllvm}/bin/gclang++
    export WLLVM_BC_STORE=$(mktemp -d)
  '';
  fixupPhase = ''
    mkdir -p $out
    for f in $out/lib/*.a; do
      ${pkgs.gllvm}/bin/get-bc "$f"
      mv "$f.bc" $out || true
    done
    for f in $out/bin/*; do
      ${pkgs.gllvm}/bin/get-bc "$f"

      # The "|| true" is for cases like coreutils which has an executable named
      # "[". Not sure how to handle this, get-bc doesn't seem to create a "[.bc"
      # file.
      mv "$f.bc" $out || true
    done
  '';
})
