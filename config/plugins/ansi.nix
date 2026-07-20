{ config, lib, pkgs, ... }:

let
  cfg = config.vim.ansi;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.ansi = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ansi color escape";
    };
  };

  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.baleia.package;
        name = "baleia";
        config.__raw =''
          function()
            vim.g.baleia = require("baleia").setup({ })
          end
        '';
        event = "VimEnter";
      }
    ];

    autoCmd = [] ++ (lib.optionals config.vim.snacks.dashboard.enable [
      {
        event = [
          "BufWinEnter"
        ];
        pattern = [
          "snacks_dashboard"
        ];
        callback.__raw = /*lua*/ ''
          function()
            vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
          end
        '';
      }
    ]);
    userCommands = {
      "BaleriaColorize" = {
        command.__raw = /*lua*/ ''
          function()
            vim.g.baleia.once(vim.api.nvim_get_current_buf())
          end
        '';
        bang = true;
      };
    };
  };
}

