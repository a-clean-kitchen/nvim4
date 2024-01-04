{ config, lib, pkgs, ... }:

let 
  cfg = config.vim;
  inherit (lib) mkOption;
in {
  options.vim = {
    leader = mkOption {
      type = lib.types.str;
      default = " ";
      description = "The leader key for vim";
    };
  };

  config = {
    vim.startLuaConfigRC = ''
      vim.g.mapleader = '${cfg.leader}'
      vim.g.maplocalleader = '${cfg.leader}'
    '';
  };
}