{ pkgs ? import <unstable> { }
, debug ? false
}:
let extractMakefile = import ./extract-makefile.nix;
    extractConfigure = import ./extract-configure.nix;
in rec {
  trace = if debug then x: y: builtins.trace x y else (msg: val: val);
  hasMakefile = drv:
    let yes_or_no = builtins.readFile "${extractMakefile { inherit (pkgs) stdenv; inherit debug drv; }}/yes-or-no.log";
        result = yes_or_no == "yes";
    in trace ("hasMakefile ${drv.name}: ${yes_or_no}") result;
  hasConfigure = drv:
    let yes_or_no = builtins.readFile "${extractConfigure { inherit (pkgs) stdenv; inherit debug drv; }}/yes-or-no.log";
        result = yes_or_no == "yes";
    in trace ("hasConfigure ${drv.name}: ${yes_or_no}") result;
}
