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

    vim.nmap = {
      "<leader>bF" = {
        mapping = "<Cmd>Format<CR>";
        description = "Format current buffer!";
      };
    };

    vim.luaConfigRC = /*lua*/ ''
       -- Utilities for creating configurations
      local fmt_util = require "formatter.util"

      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      formatter.setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        filetype = {
          typescriptreact = {
            require("formatter.filetypes.typescript").prettier,
          },
          typescript = {
            require("formatter.filetypes.typescript").prettier,
          },
          javascriptreact = {
            require("formatter.filetypes.javascript").prettier,
          },
          javascript = {
            require("formatter.filetypes.javascript").prettier,
          },
        }
      }
    '';
  };
}
