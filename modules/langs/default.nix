{ config, lib, pkgs, ... }:

{
  imports = [
    ./go.nix
    ./lua.nix
    ./nix.nix 
    ./zig.nix
    ./html.nix
    ./rust.nix
    ./python.nix
    ./typescript.nix
  ];
}
