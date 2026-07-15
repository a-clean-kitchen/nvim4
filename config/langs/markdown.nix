{ config, lib, pkgs, ... }:

let
  cfg = config.vim.glow;

  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
in
{
  options.vim.glow = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ";
    };
  };


  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.render-markdown.package;
        dependencies = with pkgs.vimPlugins; [
          nvim-web-devicons
          nvim-treesitter
        ];
        name = "render-markdown";
        opts = {
          completions = {
            lsp.enabled = true;
          };
        };
        ft = [
          "markdown"
        ];
        keys = mkLazyKeys [
          {
            bind = "<leader>mdt";
            cmd = "<cmd>RenderMarkdown toggle<cr>";
            desc = "Toggle Markdown Viewer";
          }
        ];
      }
    ];
  };
}
