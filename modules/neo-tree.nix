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
      require('neo-tree').setup({
        filesystem = {
          hijack_netrw_behavior = "open_current"
        },
      })

      ${writeIf config.vim.theme.transparency ''
      require('transparent').clear_prefix('NeoTree')
      ''}
    '';

    vim.nmap = {
      "<leader>tf" = {
        mapping = ":Neotree filesystem reveal float<CR>";
        description = "Open filesystem";
      };
      "<leader>bf" = {
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
