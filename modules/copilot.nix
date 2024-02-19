{ config, lib, pkgs, ... }:

let
  cfg = config.vim.copilot;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      copilot-lualine
      copilot-cmp
      copilot-lua
    ];

    vim.startLuaConfigRC = ''
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    '';
  };
}
