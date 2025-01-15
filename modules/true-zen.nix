{ config, lib, pkgs, ... }:

let
  cfg = config.vim.true-zen;
in {
  config = {
    vim.startPlugins = with pkgs.vimPlugins; [
      true-zen
      twilight
    ];

    vim.luaConfigRC = ''
      require("true-zen").setup({
        integrations = {
          twilight = true
        }
      })
    '';

    vim.nmap = {
      "<leader>zn" = {
        mapping = ":TZNarrow<CR>";
        description = "Narrow zen";
      };
      "<leader>zf" = {
        mapping = ":TZFocus<CR>";
        description = "Focus zen";
      };
      "<leader>zm" = {
        mapping = ":TZMinimalist<CR>";
        description = "Minimalist zen";
      };
      "<leader>za" = {
        mapping = ":TZAtaraxis<CR>";
        description = "Ataraxis zen";
      };
    };

    vim.vmap = {
      "<leader>zn" = {
        mapping = ":'<,'>TZNarrow<CR>";
        description = "Narrow zen";
      };
    };
  };
}
