{ config, lib, pkgs, ... }:

let
  cfg = config.vim.autocomplete;
  inherit (lib) mkIf mkOption;
  inherit (builtins) types;
in
{
  options.vim = {
    autocomplete = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable autocomplete (nvim-cmp)";
      };
    };
  };

  config = mkIf cfg.enable {
    
  };
}
