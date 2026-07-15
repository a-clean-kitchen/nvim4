{ config, lib, ... }:

let
  cfg = config.vim.lang;

  inherit (lib) mkIf mkOption types;
in
{
  imports = [
    ./go.nix
    ./lua.nix
    ./nix.nix
    ./zig.nix
    ./html.nix
    ./rust.nix
    ./python.nix
    ./markdown.nix
    ./typescript.nix
  ];

  options.vim.lang = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "All things language-and-lsp specific";
    };
  };

  config = mkIf cfg.enable {
    lsp = {
      servers."*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };
    };
  };
}
