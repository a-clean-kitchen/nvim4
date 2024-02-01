{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
  inherit (lib) mkOption mkIf;
in
{
  options.vim.ts.enable = mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable enable treesiter";
  };

  config = mkIf cfg.enable {
    vim.luaConfigRC = ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
          },

          indent = {
            enable = true,
          },

          incremental_selection = {
            enable = true,
          },
        }
    '';
    vim.tsGrammars = [ "nix" ];
    vim.startPlugins = with pkgs.vimPlugins;
      [ nvim-treesitter.withAllGrammars ];
  };
}
