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
        config.__raw = /*lua*/ ''
          function()
            vim.g.baleia = require("baleia").setup({ })

            -- Command to colorize the current buffer
            vim.api.nvim_create_user_command("BaleiaColorize", function()
              vim.g.baleia.once(vim.api.nvim_get_current_buf())
            end, { bang = true })

            ${lib.optionalString config.vim.snacks.dashboard.enable ''vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
              pattern = "snacks_dashboard",
              callback = function()
                vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
              end,
            })''}
          end
        '';
        event = "VimEnter";
      }
    ];
  };
}

