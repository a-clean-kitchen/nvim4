{ config, lib, ... }:

let
  cfg = config.vim.lang.go;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.go = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [
      "go"
      "gomod"
      "gosum"
    ];
    lsp.servers.gopls = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        cmd = [ "gopls" ];
        filetypes = [
          "go"
          "gomod"
          "gowork"
        ];
        settings = {
          gopls = {
            analyses = {
              unusedparams = true;
            };
            staticcheck = true;
          };
        };
      };
    };
  };
}
