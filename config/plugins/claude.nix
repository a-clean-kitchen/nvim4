{ config, lib, pkgs, ... }:

let
  cfg = config.vim.claude;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.claude = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable claude";
    };
  };


  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      # TODO: Implement claudecode.nvim
      # https://github.com/coder/claudecode.nvim
      {
        pkg = config.plugins.vimPlugins.claudecode.package;
      }
    ];
  };
}
