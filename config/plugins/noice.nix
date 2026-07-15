{ config, lib, pkgs, ... }:

let
  cfg = config.vim.noice;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.noice = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu";
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [
        "markdown"
        "markdown_inline"
        "vim"
        "regex"
        "lua"
        "bash"
    ];
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.noice.package;
        dependencies = with pkgs.vimPlugins; [
          nui-nvim
          nvim-notify
        ];
        name = "noice";
        opts = {
          lsp.override = {
            "cmp.entry.get_documentation" = false;
            "vim.lsp.util.convert_input_to_markdown_lines" = false;
            "vim.lsp.util.stylize_markdown" = false;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = true;
          };
        };
        event = [ "VeryLazy" ];
      }
    ];
  };
}
