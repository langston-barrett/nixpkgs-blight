# Create LLVM bitcode with GLLVM

{ pkgs ? import <unstable> { }
, pkgsCross ? (import <unstable> { }).pkgsCross.aarch64-multiplatform # import <unstable> { }
, llvmCcName ? "aarch64-unknown-linux-gnu-clang"  # "clang"
, llvmCxxName ? "aarch64-unknown-linux-gnu-clang++"
, name ? "entr"
, debug ? false
, lib ? import ./lib.nix { inherit debug; }
}:

lib.trace ("bitcode ${name}")
  (import ./instrument.nix {
  inherit debug pkgs pkgsCross;
  drv = pkgsCross.${name};
  # drv = (pkgs.callPackage ./openssl.nix { }).openssl_1_0_2;
  # drv = pkgs.callPackage ./nasm.nix { };
  # stdenv = pkgs.clangStdenv;
  blightEnv = ''
    export LLVM_CC_NAME=${llvmCcName}
    export LLVM_CXX_NAME=${llvmCxxName}
    export BLIGHT_WRAPPED_CC=${pkgs.gllvm}/bin/gclang
    export BLIGHT_WRAPPED_CXX=${pkgs.gllvm}/bin/gclang++
    export WLLVM_BC_STORE=$(mktemp -d)
    export BLIGHT_ACTIONS=InjectFlags
    export BLIGHT_ACTION_INJECTFLAGS="CFLAGS='-fno-slp-vectorize -fno-vectorize -fno-discard-value-names'"
  '';
  fixupPhase = ''
    if [[ -n $debug ]]; then
      mkdir -p $debug
      touch $debug/.debug
    fi
    mkdir -p $out
    # OpenSSL:
    if [[ -n $doc ]]; then
      mkdir -p $doc
      touch $doc/.doc
    fi
    for f in $out/bin/** $bin/bin/**; do
      if [[ -f "$f" ]] && [[ -x "$f" ]] && ${pkgs.file}/bin/file "$f" | grep -q "GNU/Linux"; then
        printf "get-bc %s\n" "$f"
        ${pkgs.gllvm}/bin/get-bc -o "$f.bc" "$f"
        if [[ -d $bin ]]; then
          cp "$f.bc" $out
        fi
        mv "$f.bc" $out
      fi
    done
  '';
})
