{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix.nix 
    ./typescript.nix
    ./lua.nix
  ];
}
