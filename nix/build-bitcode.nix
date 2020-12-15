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
  '';
  fixupPhase = ''
    rm -rf $out
    mkdir -p $out
    for f in $out/bin/*; do
      ${pkgs.gllvm}/bin/get-bc $f
      mv $f.bc $out
    done
  '';
})
