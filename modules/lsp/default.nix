{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
  inherit (lib) mkOption mkIf;
in
{
  imports = [
    ./capabilities.nix
    # ./nix.nix
    # ./ts.nix
    # ./go.nix
  ];

  options.vim.lsp.enable = mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable lspconfig";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.myVimPlugins; [
      nvim-lspconfig
    ];

    vim.startLuaConfigRC = ''
      -- Enable lspconfig
      local lspconfig = require('lspconfig')
      ${cfg.capabilities}
    '';
  };
}
