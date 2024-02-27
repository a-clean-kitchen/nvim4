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

    vim.startLuaConfigRC = /*lua*/ ''
      local status, lspsaga = pcall(require, 'lspsaga')
      if (not status) then return end
      lspsaga.setup({
        lightbulb = {
          enable = false
        },
        diagnostic = {
          show_code_action = false
        }
      })
    '';

    vim.luaConfigRC = let
      lspsagaMap = vimBindingPre {};
      nKeys = {
        "<C-j>" = {
          mapping = "<Cmd>Lspsaga diagnostic_jump_next<CR>";
          description = "Jump to next diagnostic";
        };
        "K" = {
          mapping = "<Cmd>Lspsaga hover_doc<CR>";
          description = "Show hover documentation";
        };
        "gd" = {
          mapping = "<Cmd>Lspsaga finder<CR>";
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
        "cA" = {
          mapping = "<cmd>Lspsaga code_action<CR>";
          description = "Code action";
        };
      };
      iKeys = {
        "<C-k>" = {
          mapping = "<Cmd>Lspsaga signature_help<CR>";
          description = "Show signature_help";
        };
      };
    in ''
      vim.keymap.set({'n', 't'}, '<A-d>', '<cmd>Lspsaga term_toggle<CR>', { desc = "Toggle the FLoating Terminal"})
      ${(concatStringsSep "\n" (lspsagaMap "nmap" nKeys))}
      ${(concatStringsSep "\n" (lspsagaMap "imap" iKeys))}
    '';
  };
} 
