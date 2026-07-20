{ config, lib, ... }:

let
  cfg = config.vim.which-key;
  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
in {
  options.vim.which-key = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    groups = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      default = [];
    };
  };

  config = mkIf cfg.enable {
    vim.which-key.groups = [
      {
        __unkeyed-1 = "<leader>f";
        group = "finders";
      }
    ];
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.which-key.package;
        name = "which-key";
        event = "VeryLazy";
        opts = {
          preset = "modern";
          spec = [] ++ cfg.groups;
        };
        keys = mkLazyKeys [
          {
            bind = "<leader>?";
            cmd = "<Cmd>WhichKey<CR>";
          }
        ];
      }
    ];
  };
}
