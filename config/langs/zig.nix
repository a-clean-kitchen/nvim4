{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.zig;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.zig = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [
      "zig"
    ];
    lsp.servers.zls = {
      inherit (cfg) enable;
      packageFallback = false;
      config = {
        filetypes = [
          "zig"
          "zir"
        ];
        root_markers = [
          "zls.json"
          "build.zig"
        ];
        cmd = [ "zls" ];
      };
    };
  };
}
