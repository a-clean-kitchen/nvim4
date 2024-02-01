{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lualine;

  inherit (lib.my) writeIf;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      lualine
    ];

    vim.luaConfigRC = ''
      local status, lualine = pcall(require, "lualine")
      if (not status) then return end
      lualine.setup({
        options = {
          theme = "${config.vim.theme.name}",
        }
      })

      ${writeIf config.vim.theme.transparency ''
      require('transparent').clear_prefix('lualine')
      ''}
    '';
  };
}
