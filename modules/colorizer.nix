{ config, lib, pkgs, ... }:

let 
  cfg = config.vim.colorizer;
in {
  config = {
    vim.startPlugins = with pkgs.vimPlugins; [
      nvim-colorizer
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, colorizer = pcall(require, "colorizer")
      if (not status) then return end
    '';

    vim.luaConfigRC = /*lua*/ ''
      colorizer.setup()
    '';
  };
}
