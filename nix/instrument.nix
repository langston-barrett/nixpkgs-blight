{ pkgs ? import <unstable> { }
, debug ? false
, lib ? import ./lib.nix { inherit debug; }
, blight ? pkgs.python3Packages.callPackage ./blight.nix { }
, stdenv ? pkgs.stdenv
, blightEnv ? ''
  mkdir -p $out
  export BLIGHT_ACTIONS="Record"
  export BLIGHT_ACTION_RECORD="output=$out/record.jsonl"
''
, fixupPhase ? ""
, extraAttrs ? oldAttrs: {}
, drv
}:

assert lib.hasMakefile drv || lib.hasConfigure drv;

let
  warn = "[WARN] Not overriding stdenv for derivation ";
  overridden =
    if drv ? override
    then drv.override { inherit stdenv; }
    else builtins.trace (warn + drv.name) drv;
  setBlightEnv = ''
    eval $(${blight}/bin/blight-env --guess-wrapped)
    ${blightEnv}
  '';
in lib.trace "instrument ${drv.name}" (overridden.overrideAttrs (oldAttrs: {
  buildInputs =
    [ pkgs.clang pkgs.llvm pkgs.file blight ] ++ oldAttrs.buildInputs or [];
  preBuild = setBlightEnv + oldAttrs.preBuild or "";
  preConfigure = setBlightEnv + oldAttrs.preBuild or "";
  makeFlags = oldAttrs.makeFlags or [] ++ ["CC=blight-cc" "CXX=blight-cxx"];
  fixupPhase = oldAttrs.fixupPhase or "" + fixupPhase;
  doCheck = false;
  # This break installation of manpages, etc.
  # outputs = [ "out" ];
} // extraAttrs oldAttrs))
