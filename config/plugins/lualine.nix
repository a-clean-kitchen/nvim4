{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lualine;
  icons = config.vim.icons.extra;

  inherit (lib) mkIf mkOption types;
  inherit (lib.nixvim.lua) toLuaObject; 
in
{
  options.vim.lualine = {
    enable = mkOption {
      type = types.bool;
      default = true;
description = "A blazing fast and easy to configure neovim statusline written in lua";
    };
  };


  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.lualine.package;
        dependencies = with pkgs.vimPlugins; [
          nvim-web-devicons
        ];
        name = "lualine";
        config.__raw = /*lua*/ ''
          function()
          -- Helper functions ------------------------------------------------------------

            local utils = require("lualine.utils.utils")
          local modes = {
              "normal",
              "insert",
              "visual",
              "replace",
              "command",
              "inactive",
              "terminal",
          }
          local expand_mode = {
              ["n"] = "normal",
              ["no"] = "normal",
              ["nov"] = "normal",
              ["noV"] = "normal",
              ["no\22"] = "normal",
              ["niI"] = "insert",
              ["niR"] = "replace",
              ["niV"] = "replace",
              ["v"] = "visual",
              ["V"] = "visual",
              ["\22"] = "visual",
              ["s"] = "visual",
              ["S"] = "visual",
              ["\19"] = "visual",
              ["i"] = "insert",
              ["ic"] = "insert",
              ["ix"] = "insert",
              ["R"] = "replace",
              ["Rc"] = "replace",
              ["Rx"] = "replace",
              ["Rv"] = "replace",
              ["c"] = "command",
              ["cv"] = "command",
              ["ce"] = "command",
              ["r"] = "command",
              ["rm"] = "command",
              ["r?"] = "command",
              ["!"] = "command",
              ["t"] = "terminal",
          }
          local function bufferinfo()
              local bufs = vim.fn.getbufinfo({ buflisted = 1 })
              local current_buf = vim.api.nvim_get_current_buf()
              for index, buf in ipairs(bufs) do
                  if buf.bufnr == current_buf then
                      return { index = index, count = #bufs }
                  end
              end
          end

          -- Adjust theme ----------------------------------------------------------------

          local function adjusted_auto()
              package.loaded["lualine.themes.auto"] = nil
              local status, theme = pcall(require, "lualine.themes.auto")
              if not status then
                  return "auto"
              end

              for _, modename in ipairs(modes) do
                  if theme[modename] then
                      if theme[modename].a then
                          theme[modename].a.gui = ""
                      end
                      if theme[modename].b then
                          theme[modename].b.bg =
                              utils.extract_highlight_colors("TabLine", "bg")
                      end
                      if theme[modename].c then
                          theme[modename].c.bg = "NONE"
                      end
                  end
              end

              return theme
          end

          local function adjust_colors()
              -- Kill underlying Neovim statusline backgrounds
              for _, hlname in ipairs({ "StatusLine", "StatusLineNC" }) do
                  vim.api.nvim_set_hl(0, hlname, { bg = "NONE", ctermbg = "NONE" })
              end

              -- Repopulate adjusted highlight groups
              for _, modename in ipairs(modes) do
                  local base_lualine_a = "lualine_a_" .. modename
                  local base_lualine_b = "lualine_b_" .. modename

                  vim.api.nvim_set_hl(0, "lualine_b_" .. modename .. "_transparent", {
                      fg = utils.extract_highlight_colors(base_lualine_b, "fg"),
                      bg = "NONE",
                  })

                  vim.api.nvim_set_hl(0, "lualineItalicCrumb_" .. modename, {
                      fg = utils.extract_highlight_colors(base_lualine_a, "fg"),
                      bg = utils.extract_highlight_colors(base_lualine_a, "bg"),
                      italic = true,
                  })
              end
          end

          vim.api.nvim_create_autocmd( {"ColorScheme", "VimEnter"} , {
              group = vim.api.nvim_create_augroup(
                  "LualineTransparentRefresh",
                  { clear = true }
              ),
              callback = function()
                  require("lualine").setup({
                      options = {
                          theme = adjusted_auto(),
                      },
                  })
                  adjust_colors()
              end,
          })
          require('lualine').setup({
            options = {
              globalstatus = true,
              section_separators = "",
              component_separators = "",
              always_divide_middle = false,
              ignore_focus = { "help" },
              disabled_filetypes = {
                "NvimTree",
                "lazy"
              },
            },
            sections = {
              lualine_a = { "mode" },
              lualine_b = {},
              lualine_c = {
                "filename",
                {
                  "lsp_status",
                  icon = "${icons.ui.LSP}",
                  symbols = {
                    spinner = ${toLuaObject icons.spinner},
                    done = "",
                    separator = " ",
                  },
                  ignore_lsp = {},
                  show_name = true,
                }
              },
              lualine_x = {
                {
                  "diff",
                  symbols = {
                    added = "${icons.git.LineAdded + " "}",
                    modified = "${icons.git.LineModified + " "}",
                    removed = "${icons.git.LineRemoved + " "}",
                  },
                  colored = true,
                  always_visible = false,
                  source = function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if gitsigns then
                      return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                      }
                    end
                  end,

                },
                {
                  "diagnostics",
                  sources = ${toLuaObject [ "nvim_lsp" "nvim_diagnostic" ]},
                  sections = ${toLuaObject [ "error" "warn" "info" "hint" ]},
                  symbols = {
                    error = "${icons.diagnostics.Error}",
                    hint = "${icons.diagnostics.Hint}",
                    info = "${icons.diagnostics.Info}",
                    warn = "${icons.diagnostics.Warning}",
                  },
                  colored = true,
                  update_in_insert = false,
                  always_visible = false,

                },
                {
                  "filetype",
                  icon_only = true,
                }
              },
              lualine_y = {},
              lualine_z = {},
            },
          })
          end
        '';
      }
    ];
  };
}
