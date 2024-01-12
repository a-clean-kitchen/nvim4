{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.which-key;
in {
  config = {
    vim = {
      startPlugins = with pkgs.myVimPlugins; [
        which-key
      ];
      startLuaConfigRC = ''
        local wk = require("which-key")
      '';
      luaConfigRC = ''
        require("which-key").setup {}
      '';
    };
  };
}
