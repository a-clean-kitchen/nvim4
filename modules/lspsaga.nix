{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lspsaga;
  inherit (lib) 
in {
  options.vim.lspsaga = {
    enable = mkOption {

    };
  };
}; 
