{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.nix;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [ "nix" ];
    lsp.servers.nixd = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        cmd = [ "nixd" ];
        filetypes = [ "nix" ];
        root_markers = [ 
          "flake.nix"
          "default.nix"
        ];
        settings = {
          nixd = {
            nixpkgs.expr = "import <nixpkgs> { }";
            formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
            options = {
              nixos = {
                expr = # nix
                  ''
                    (builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations."junkr".options
                  '';
              };
              home_manager = {
                expr = # nix
                  ''
                    (builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."qm@junkr".options
                  '';
              };
            };
          };
        };
      };
    };
  };
}
