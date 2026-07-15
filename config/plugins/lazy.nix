{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lazy;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lazy = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "specify folke's lazy loader";
    };
  };


  config = mkIf cfg.enable {

    extraConfigLuaPost = ''
      vim.go.loadplugins = true
    '';
    plugins = {
      lz-n.enable = false;
      lazy = {
        enable = true;
        # Keep settings.spec non-empty so lazy.nvim treats settings as opts,
        # while still sourcing neocord through Nixvim's managed plugin option.
        settings = {
          rocks.enabled = false;
          performance = {
            # Nixvim manages plugins via packpath; lazy.nvim must not reset it
            reset_packpath = false;
            rtp = {
              reset = false;
            };
          };
        };
      };
    };
  };
}
