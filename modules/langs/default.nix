{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix.nix 
    ./zig.nix
    ./go.nix
    ./typescript.nix
    ./lua.nix
  ];
}
