# Extract a Makefile from a package, if it has one
{ stdenv
, drv
, debug ? false
}:

stdenv.mkDerivation (import ./do-nothing-attrs.nix // {
  name = "${drv.name}-extract-makefile";
  src = drv.src;
  unpackPhase = drv.unpackPhase or "";
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir $out
    if [[ -f GNUMakefile ]]; then
      cp GNUMakefile $out/Makefile
    elif [[ -f Makefile ]]; then
      cp Makefile $out/Makefile
    elif ls Makefile.* > /dev/null; then
      for f in Makefile.*; do
        cp $f $out/Makefile
        break
      done
    # https://nixos.org/manual/nixpkgs/stable/#build-phase
    elif [[ -f "${drv.makefile or "Makefile"}" ]]; then
      cp "${drv.makefile or "Makefile"}" "$out/Makefile"
    fi

    if [[ -f $out/Makefile ]]; then
      printf "yes" > $out/yes-or-no.log
    else
      printf "no" > $out/yes-or-no.log
    fi
    if [[ ${builtins.toString debug} == 1 ]]; then
      printf "extract-makefile ${drv.name}: %s" $(cat $out/yes-or-no.log)
    fi
  '';
})
