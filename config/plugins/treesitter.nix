{ config, pkgs, lib, ... }:

let 
  inherit (lib) mkOption types;
  inherit (lib) mkListOfAttrs;
in {
  options.vim = {
    tsGrammars = mkOption {
      description = "List of treesitter grammars to load";
      default = [ ];
      type = with types; listOf str;
    };
  };

  config = {
    vim.tsGrammars = [
      # dotfile formats
      "rasi"
      "toml"
      "editorconfig"
      "hyprlang"
      "fish"
      "tmux"
      "yuck"

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
    plugins.treesitter = {
      enable = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
      nixvimInjections = true;
      grammarPackages = (mkListOfAttrs config.vim.tsGrammars config.plugins.treesitter.package.builtGrammars);
    };
  };
}
