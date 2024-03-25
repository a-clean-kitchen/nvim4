{ config, lib, pkgs, ... }:

let
  cfg = config.vim.luasnip;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim = {
    luasnip = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable luasnip";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.myVimPlugins; [
      luasnip
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, luasnip = pcall(require, "luasnip")
      if (not status) then return end
    '';
  };
}
