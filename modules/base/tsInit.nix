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
        # dotfile formats
        "rasi"
        "toml"
        "editorconfig"
        "hyprlang"
        "fish"
        "tmux"

        # git
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"

        # linux admin formats
        "ssh_config"
        "passwd"

        # documentation
        "comment"
        "vimdoc"

        # various stray dev stuff
        "yaml"
        "sql"
        "cmake"
        "css"
        "dockerfile"
        "c"
        "c_sharp"
        "http"
        "java"
        "jq"
        "json"
        "make"
        "hcl"
        "terraform"
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
