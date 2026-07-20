{ config, lib, pkgs, ... }:

let
  cfg = config.vim.snacks.terminal;

  inherit (lib) mkIf mkOption types optionalAttrs;
  inherit (lib) mkRaw;
in
{
  options.vim.snacks.terminal = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable snacks terminal";
    };
    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
  };


  config = mkIf cfg.enable {
    userCommands = {
      "ToggleFloatingTerminal" = {
        command.__raw = ''
          function()
            local tglOpts = {
              win = {
                wo = {
                  wrap = true,
                },
                position = "float",
                title = "Duh Terminul",
                title_pos = "center",
                border = "rounded",
                width = 0.75,
                height = 0.75,
              },
            }

            require('snacks').terminal.toggle("fish", tglOpts)
          end
        '';
      };
    };
    keymaps = [
      {
        action = "<cmd>ToggleFloatingTerminal<cr>";
        key = "<A-d>";
        mode = [ "n" "t" ];
        options.desc = "Toggle Terminal";
      }
    ];
    vim.snacks.terminal = {
      settings = optionalAttrs cfg.enable {
        enabled = cfg.enable;
        bo = {
          filetype = "snacks_terminal";
        };
      };
    };
  };
}
