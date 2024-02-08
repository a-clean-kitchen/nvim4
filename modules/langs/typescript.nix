{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      
    ];

    vim.luaConfigRC = ''
      
    '';
  };
}
