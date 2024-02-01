{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix.nix 
    ./lua.nix
  ];
}
