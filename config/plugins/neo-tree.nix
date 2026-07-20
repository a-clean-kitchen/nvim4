{ config, lib, pkgs, ... }:

let
  cfg = config.vim.neo-tree;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.neo-tree = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ";
    };
  };


  config = mkIf cfg.enable {
    extraConfigLuaPre = /*lua*/ ''
      -- Neo-tree hack
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrwSettings = 1
      vim.g.loaded_netrwFileHandlers = 1
    '';
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.neo-tree.package;
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          nvim-notify
          nvim-web-devicons
        ];
        name = "neo-tree";
        opts = {
          hijack_netrw_behavior = "open_current";
          window = {
            mappings = {
              "P" = {
                __unkeyed-1 = "toggle_preview";
                config = {
                  use_float = true;
                  us_image_nvim = true;
                  title = "Neo-tree Preview";
                };
              };
            };
          };
        };
        event = [ "VeryLazy" ];
      }
    ];
    keymaps = [
      {
        action = "<cmd>Neotree filesystem reveal float<CR>";
        key = "<leader>F";
        mode = [ "n" ];
        options.desc = "Open filesystem";
      }
      {
        action = "<cmd>Neotree git_status reveal float<CR>";
        key = "<leader>gs";
        mode = [ "n" ];
        options.desc = "Git Status";
      }
    ];
  };
}
