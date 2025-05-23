{ config, lib, pkgs, ... }:

let
  cfg = config.vim.noice;
in {
  config = {
    vim = {
      tsGrammars = [
        "markdown"
        "markdown_inline"
        "vim"
        "regex"
        "lua"
        "bash"
      ];

      startLuaConfigRC = /*lua*/''
        local status, noice = pcall(require, 'noice')
        if (not status) then return end

        local status, notify = pcall(require, 'notify')
        if (not status) then return end
      '';
      
      startPlugins = with pkgs.vimPlugins; [
        noice-nvim
        nui
        nvim-notify
      ];

      luaConfigRC = /*lua*/ ''
        noice.setup({
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
          },
        })

        notify.setup({
          background_colour = "#000000"
        })
      '';
    };
  };
}
