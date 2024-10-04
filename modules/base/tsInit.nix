{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
  inherit (lib) mkOption mkIf attrVals;
in
{
  options.vim.ts.enable = mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable enable treesiter";
  };

  config = mkIf cfg.enable {
    vim = {
      # Misc Grammars 
      tsGrammars = [
        "cmake"
        "dockerfile"
        "editorconfig"
        "fish"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "http"
        "hyprlang"
        "java"
        "jq"
        "json"
        "make"
        "ssh_config"
        "hcl"
        "terraform"
        "tmux"
        "vimdoc"
        "yaml"
      ];
      luaConfigRC = ''
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
      startPlugins = [ (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: (attrVals config.vim.tsGrammars p))) ];
    };
  };
}
