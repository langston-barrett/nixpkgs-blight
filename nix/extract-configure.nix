# Extract a configure script from a package, if it has one
{ stdenv
, drv
, debug ? false
}:

stdenv.mkDerivation (import ./do-nothing-attrs.nix // {
  name = "${drv.name}-extract-configure";
  src = drv.src;
  unpackPhase = drv.unpackPhase or "";
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir "$out"
    if [[ -f configure ]]; then
      cp configure "$out/configure"
    elif [[ -f config ]]; then
      cp config "$out/configure"
    # https://nixos.org/manual/nixpkgs/stable/#configure-phase
    elif [[ -f "${drv.configureScript or "configure"}" ]]; then
      cp "${drv.configureScript or "configure"}" $out/configure
    fi

    if [[ -f "$out/configure" ]]; then
      printf "yes" > $out/yes-or-no.log
    else
      printf "no" > $out/yes-or-no.log
    fi
    if [[ ${builtins.toString debug} == 1 ]]; then
      printf "extract-configure ${drv.name}: %s" $(cat $out/yes-or-no.log)
    fi
  '';
})
