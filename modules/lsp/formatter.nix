{ config, lib, pkgs, ... }:

let
  cfg = config.lsp.formatter;

  inherit (lib) mkIf mkOption types;
in
{
  options.lsp.formatter = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable formatting";
      };
    };
  

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.myVimPlugins; [
      formatter
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, formatter = pcall(require, "formatter")
      if (not status) then return end
    '';

    vim.luaConfigRC = /*lua*/ ''
      -- Utilities for creating configurations
      local fmt_util = require "formatter.util"

      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      formatter.setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
      }
    '';
  };
}
