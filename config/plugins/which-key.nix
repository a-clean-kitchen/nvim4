{ config, lib, ... }:

let
  cfg = config.vim.which-key;
  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
in {
  options.vim.which-key.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.which-key.package;
        name = "which-key";
        event = "VeryLazy";
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
