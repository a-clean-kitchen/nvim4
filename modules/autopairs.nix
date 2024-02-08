{ config, lib, pkgs, ... }:

let
  cfg = config.vim.autopairs;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      autopairs
    ];

    vim.startLuaConfigRC = ''
      local status, autopairs = pcall(require, "nvim-autopairs")
      if (not status) then return end
    '';
    
    vim.luaConfigRC = ''
      autopairs.setup({
        disable_filetype = { "TelescopePrompt" , "vim" },
      })
    '';
  };
}
