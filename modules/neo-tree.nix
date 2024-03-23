{ config, lib, pkgs, ... }:

let
  cfg = config.vim.neo-tree;

  inherit (lib.my) writeIf;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      neo-tree
      third-image
    ];

    vim.luaConfigRC = ''
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrwSettings = 1
      vim.g.loaded_netrwFileHandlers = 1

      require('neo-tree').setup({
        hijack_netrw_behavior = 'open_current',
      })
    '';

    vim.nmap = {
      "<leader>F" = {
        mapping = ":Neotree filesystem reveal float<CR>";
        description = "Open filesystem";
      };
      "<leader>lb" = {
        mapping = ":Neotree buffers reveal float<CR>";
        description = "Open buffers";
      };
      "<leader>gs" = {
        mapping = ":Neotree git_status reveal float<CR>";
        description = "Git Status";
      };
    };
  };
}
