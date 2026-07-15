{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.rust;

  inherit (lib) mkIf mkOption types;
  inherit (lib.nixvim) mkRawKey;
in
{
  options.vim.lang.rust = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [
      "rust"
    ];
    lsp.servers.rust_analyzer = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        cmd = [ "rust-analyzer" ];
        filetypes = [
          "rust"
        ];
        settings = {} //
          (mkRawKey "'rust-analyzer'" {
            diagnostics.enable = false;
        });
      };
    };
  };
}
