{ pkgs ? import <nixpkgs> { }, packages }:

with pkgs;
let
  nixBin =
    writeShellScriptBin "nix" ''
      ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
    '';
in
mkShell {
  buildInputs = [
    git
    nixpkgs-fmt
    # packages."x86_64-linux".default
  ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
