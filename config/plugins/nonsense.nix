{ config, lib, pkgs, ... }:

let
  cfg = config.vim.nonsense;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.nonsense = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable random nonsense plugins in neovim";
    };
  };


  config = mkIf cfg.enable {};
}
