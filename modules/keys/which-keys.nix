{ config, lib, pkgs, ... }:

let
  cfg = config.vim.which-key;

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
      startPlugins = with pkgs.myVimPlugins; [
        which-key
      ];
      startLuaConfigRC = ''
        local wk = require("which-key")
      '';
      luaConfigRC = ''
        require("which-key").setup {}
      '';
    };
  };
}
