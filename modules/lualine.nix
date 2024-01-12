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
      require('lualine').setup({
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
