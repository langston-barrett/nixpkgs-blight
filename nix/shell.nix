{ pkgs ? (import <unstable> { }).pkgsCross.aarch64-multiplatform
, pkgsCross ? (import <unstable> { }).pkgsCross.aarch64-multiplatform
, name ? "hello"
}:

import ./build-bitcode.nix {
  inherit pkgs pkgsCross name;
}
