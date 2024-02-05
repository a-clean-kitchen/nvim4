{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lspsaga;
  inherit (lib.my) vimBindingPre;
  inherit (builtins) concatStringsSep;
in {
#   options.vim.lspsaga = {
#     enable = mkOption {
# 
#     };
#   };
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      nvim-lspsaga
    ];
    vim.startLuaConfigRC = ''
    local status, lspsaga = pcall(require, 'lspsaga')
    if (not status) then return end
    lspsaga.setup({})
    '';

    vim.luaConfigRC = let
      lspsagaMap = vimBindingPre {};
      nKeys = {
        "<leader>tf" = {
          mapping = "<cmd>Lspsaga term_toggle<CR>";
          description = "Toggle terminal";
        };
        "<C-j>" = {
          mapping = "<Cmd>Lspsaga diagnostic_jump_next<CR>";
          description = "Jump to next diagnostic";
        };
        "K" = {
          mapping = "<Cmd>Lspsaga hover_doc<CR>";
          description = "Show hover documentation";
        };
        "gd" = {
          mapping = "<Cmd>Lspsaga lsp_finder<CR>";
          description = "Find references";
        };
        "gp" = {
          mapping = "<Cmd>Lspsaga preview_definition<CR>";
          description = "Preview definition";
        };
        "gr" = {
          mapping = "<Cmd>Lspsaga rename<CR>";
          description = "Rename";
        };
      };
      iKeys = {
        "<C-k>" = {
          mapping = "<Cmd>Lspsaga signature_help<CR>";
          description = "Show signature help";
        };
      };
    in ''
      ${(concatStringsSep "\n" (lspsagaMap "nmap" nKeys))}
      ${(concatStringsSep "\n" (lspsagaMap "imap" iKeys))}
    '';
  };
} 
