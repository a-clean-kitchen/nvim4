{ config, lib, pkgs, ... }:

let
  cfg = config.vim.colorizer;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.colorizer = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "A high-performance color highlighter for Neovim which has no external dependencies!";
    };
  };


  config = mkIf cfg.enable {
    plugins.lua.plugins = [
      {
        pkg = config.plugins.coloizer.package;
        name = "colorizer";
        opts.__raw = "{}";
        event = [
          "VeryLazy"
        ];
      }
    ];
  };
}
