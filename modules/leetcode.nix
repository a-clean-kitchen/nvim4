{ config, lib, pkgs, ... }:

let
  cfg = config.vim.leetcode;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.leetcode = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable leetcode plugin";
    };
  };


  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.vimPlugins; [
      leetcode-nvim
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, leetcode = pcall(require, "leetcode")
      if (not status) then return end
    '';

    vim.luaConfigRC = /*lua*/ ''
      leetcode.setup {
        lang = "go",
        image_support = true,
      }
    '';
  };
}
