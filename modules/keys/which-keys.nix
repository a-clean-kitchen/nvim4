{ config, lib, pkgs, ... }:

let
  cfg = config.vim.which-key;
  inherit (lib.my) vimBindingPre;
  inherit (builtins) concatStringsSep;
  inherit (lib) mkOption types mkIf;
in {
  options.vim.which-key.enable = mkOption {
    type = types.bool;
    default = true;
    description = ''
      Enable which-key
    '';
  };

  config = mkIf cfg.enable {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        which-key
      ];
      startLuaConfigRC = /*lua*/ ''
        local status, whichKey = pcall(require, 'which-key')
        if (not status) then return end
        whichKey.setup {}
      '';
      nmap = {
        "<leader>K" = {
          mapping = "<Cmd>WhichKey<CR>";
          description = "Which Keys!";
        };
      };
    };
  };
}
