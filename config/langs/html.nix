{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.html;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.html = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [

    ];
    lsp.servers.emmet_language_server = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        filetypes = [
          "astro"
          "css"
          "eruby"
          "html"
          "htmlangular"
          "htmldjango"
          "javascriptreact"
          "less"
          "sass"
          "scss"
          "svelte"
          "typescriptreact"
          "vue"
        ];
        cmd = [
          "emmet-language-server"
          "--stdio"
        ];
      };
    };
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.ts-autotag.package;
        name = "ts-autotag";
        opts.opts.enable_close_on_slash = true;
        ft = [
          "html"
          "javascript"
          "typescript"
          "javascriptreact"
          "typescriptreact"
          "svelte"
          "vue"
          "tsx"
          "jsx"
          "xml"
          "php"
          "markdown"
          "glimmer"
        ];
      }
    ];
  };
}
