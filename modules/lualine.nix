{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lualine;

  inherit (lib.my) writeIf;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      lualine
    ];
    vim.startLuaConfigRC = ''
      local status, lualine = pcall(require, "lualine")
      if (not status) then return end
    '';
    vim.luaConfigRC = /*lua*/ ''
      lualine.setup({
        options = {
          theme = "${config.vim.theme.name}",
        },
        sections = {
          lualine_x = {
            { 
              'copilot',
              show_colors = true,
            },
            {
              require("noice").api.status.message.get_hl,
              cond = require("noice").api.status.message.has,
            },
            {
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.search.get,
              cond = require("noice").api.status.search.has,
              color = { fg = "#ff9e64" },
            },
          },
        },
      })
      ${writeIf config.vim.theme.transparency ''
        require('transparent').clear_prefix('lualine')
      ''}
    '';
  };
}
