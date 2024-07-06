{ config, lib, pkgs, ... }:

{
  imports = [
    ./go.nix
    ./nix.nix 
    ./zig.nix
    ./lua.nix
    ./html.nix
    ./rust.nix
    ./python.nix
    ./typescript.nix
  ];
}
