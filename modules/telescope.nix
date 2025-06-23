{ config, lib, pkgs, ... }:

let
  cfg = config.vim.telescope;
in {
  config = {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        telescope
        nvim-web-devicons
      ];
    
      startLuaConfigRC = ''
        local tsBuiltin = require('telescope.builtin')
      '';

      luaConfigRC = /*lua*/ ''
        vim.keymap.set('n', '<leader>ff', tsBuiltin.find_files, { desc = "Find Files" })
        vim.keymap.set('n', '<leader>fg', tsBuiltin.live_grep, { desc = "Live Grep" })
        vim.keymap.set('n', '<leader>fb', tsBuiltin.buffers, { desc = "Buffers" })
        vim.keymap.set('n', '<leader>fh', tsBuiltin.help_tags, { desc = "Help Tags" })
      '';

      # nmap = {
      #   "<leader>fdd" = {
      #     mapping = "<cmd>Telescope "
      #   };
      # };
    };
  };
}
