{ config, lib, pkgs, ... }:

let 
  cfg = config.vim.startup;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      startup-nvim
    ];

    vim.startLuaConfigRC = ''
      local status, startup = pcall(require, "startup")
      if (not status) then return end
    '';

    vim.luaConfigRC = ''
      startup.setup({theme = "dashboard"}) 
    '';
  };
}
