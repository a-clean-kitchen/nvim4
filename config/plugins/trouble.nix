{ config, lib, pkgs, ... }:

let
  cfg = config.vim.trouble;

  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
in
{
  options.vim.trouble = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.trouble.package;
        dependencies = with pkgs.vimPlugins; [
          nvim-web-devicons
        ];
        name = "trouble";
        cmd = "Trouble";
        config.__raw = /*lua*/ ''
          function()
            vim.api.nvim_create_user_command("TodoPanel", function()
              local todoOpts = {
                mode = "todo",
                focus = true,
                win = {
                  wo = {
                    wrap = true,
                  },
                  type = "float",
                  title = "TODO Panel",
                  title_pos = "center",
                  border = "rounded",
                  position = { 0.5, 0.1 },
                  size = {
                    width = 0.4,
                    height = 0.75
                  },
                },
                preview = {
                  type = "float",
                  border = "rounded",
                  position = { 0.5, 0.8 },
                  size = {
                    width = 0.4,
                    height = 0.75
                  }
                },
                keys = {
                  ["<cr>"] = {
                    action = function(view, ctx)
                      local item = ctx.item
                      if not item or not item.filename then
                        return
                      end

                        -- close Trouble first
                      view:close()

                      -- open the file
                      vim.cmd.edit(vim.fn.fnameescape(item.filename))

                      -- jump to the location
                      if item.pos then
                        vim.api.nvim_win_set_cursor(0, item.pos)
                      end
                    end,
                    desc = "Edit file and close Trouble",
                  }
                }
              }
              require('trouble').open(todoOpts)
            end, {})
          end
        '';
        keys = mkLazyKeys [
          {
            bind = "<leader>t";
            cmd.__raw = "nil";
            desc = "trouble";
          }
          {
            bind = "<leader>tx";
            cmd.__raw = ''
              function()
                require("trouble").toggle("diagnostics")
              end
            '';
            desc = "Diagnostics (Trouble)";
          }
          {
            bind = "<leader>tX";
            cmd = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
            desc = "Buffer Diagnostics (Trouble)";
          }
          {
            bind = "<leader>ts";
            cmd = "<cmd>Trouble lsp_document_symbols toggle win.type=split win.position=right win.size=0.4<cr>";
            desc = "Symbols (Trouble)";
          }
          {
            bind = "<leader>tl";
            cmd = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
            desc = "LSP Definitions / references / ... (Trouble)";
          }
          {
            bind = "<leader>tL";
            cmd = "<cmd>Trouble loclist toggle<cr>";
            desc = "Location List (Trouble)";
          }
          {
            bind = "<leader>tQ";
            cmd = "<cmd>Trouble qflist toggle<cr>";
            desc = "Quickfix List (Trouble)";
          }
          {
            bind = "<leader>td";
            cmd = "<cmd>TodoPanel<cr>";
            desc = "TODO Panel";
          }
        ];
      }
    ];
  };
}
