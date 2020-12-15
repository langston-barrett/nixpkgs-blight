# Extract CMakeLists.txt from a package, if it has one
{ stdenv,
  drv
}:

stdenv.mkDerivation (import ./do-nothing-attrs.nix // {
  name = "${drv.name}-extract-makefile";
  src = drv.src;
  unpackPhase = drv.unpackPhase or "";
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir $out
    if [[ -f CMakeLists.txt ]]; then
      cp CMakeLists.txt $out/CMakeLists.txt
    fi

    if [[ -f $out/CMakeLists.txt ]]; then
      printf "Yes\n" > $out/yes-or-no.log
    else
      printf "No\n" > $out/yes-or-no.log
    fi
  '';
})
