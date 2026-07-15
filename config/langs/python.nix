{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.python;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.python = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [
      "python"
    ];
    lsp.servers.pylsp = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        filetypes = [
          "python"
        ];
        root_markers = [
          "pyproject.toml"
          "setup.py"
          "setup.cfg"
          "requirements.txt"
          "Pipfile"
        ];
        cmp = [ "pylsp" ];
      };
    };
  };
}
