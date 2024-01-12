{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
  inherit (lib) mkOption mkIf;
in
{
  options.vim.lsp.enable = mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable lspconfig";
  };

  config = mkIf cfg.enable {
    vim.startLuaConfigRC = ''
      -- Enable lspconfig
      local lspconfig = require('lspconfig')
    '';

    vim.startPlugins = with pkgs.myVimPlugins;
      [ nvim-lspconfig ];
  };
}
