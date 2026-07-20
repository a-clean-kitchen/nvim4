{ config, lib, pkgs, ... }:

let
  cfg = config.vim.true-zen;

  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
in
{
  options.vim.true-zen = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Clean and elegant distraction-free writing for NeoVim";
    };
  };


  config = mkIf cfg.enable {
    vim.which-key.groups = [
      {
        __unkeyed-1 = "<leader>z";
        group = "zen modes";
      }
    ];
    plugins.lazy.plugins = [
      {
        pkg = pkgs.vimPlugins.true-zen-nvim;
        dependencies = with pkgs.vimPlugins; [
          twilight-nvim
        ];
        name = "true-zen";
        opts= {
          minimalist = {
            options = {
              showtabline = 0;
            };
          };
        };
        event = [
          "VeryLazy"
        ];
        keys = mkLazyKeys [
          {
						bind = "<leader>zn";
            cmd = ":TZNarrow<CR>";
            desc = "Narrow zen";
          }
          {
						bind = "<leader>zf";
            cmd = ":TZFocus<CR>";
            desc = "Focus zen";
          }
          {
						bind = "<leader>zm";
            cmd = ":TZMinimalist<CR>";
            desc = "Minimalist zen";
          }
          {
						bind = "<leader>za";
            cmd = ":TZAtaraxis<CR>";
            desc = "Ataraxis zen";
          }
        ];
      }
    ];
  };
}
