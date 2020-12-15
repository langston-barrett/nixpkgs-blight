#!/usr/bin/env bash

for pkg in $(nix eval '(builtins.attrNames (import <nixpkgs> { }))' | tr -d '[]' | sed 's/"/\n/g' | sort); do
  make "out/bitcode/${pkg}"
done
