{ config, lib, pkgs, ... }:

let
  cfg = config.vim.autocomplete;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim = {
    autocomplete = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable autocomplete";
      };
    };
  };

  config = mkIf cfg.enable {};
}
