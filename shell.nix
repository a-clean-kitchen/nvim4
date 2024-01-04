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
    packages.default
  ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
