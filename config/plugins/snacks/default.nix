{ config, lib, pkgs, ... }:

let
  cfg = config.vim.snacks;

  inherit (lib) mkIf mkOption types;
in
{
  imports = [
    ./dashboard.nix
  ];

  options.vim.snacks = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "A collection of small QoL plugins for Neovim";
    };
    pluginLuaConfig = mkOption {
      type = types.str;
      default = '''';
    };
  };

  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.snacks.package;
        name = "snacks";
        dependencies = with pkgs.vimPlugins; [
          nvim-web-devicons
          # plenary-nvim
          # telescope-fzf-native-nvim
        ];
        opts = {
          dashboard = config.vim.snacks.dashboard.settings;
        };
      }
    ];
  };
}
