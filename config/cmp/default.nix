{ config, lib, pkgs, ... }:

# Shoutout https://github.com/SeamusFD/Nievo/blob/master/config/languages/completion.nix
let
  cfg = config.vim.cmp;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.cmp = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.cmp.package;
        dependencies = with config.plugins; [
          lspkind.package
          intellitab.package
          luasnip.package
          nvim-autopairs.package

          # Various completions
          cmp-nvim-lsp.package
          cmp-buffer.package
          cmp-treesitter.package
          cmp-path.package
          cmp-cmdline.package
          cmp_luasnip.package
        ];
        name = "nvim-cmp";
        event = [
          "BufReadPre"
          "BufNewFile"
        ];
        opts.__raw = /*lua*/ ''
          function (_, opts)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            }
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local server = {
              nixd = {},
              pylss = {},
              rust_analyzer = {
                ["rust-analyzer"] = {
                  files = {
                    excludeDirs = { ".direnv", ".devenv" },
                  },
                },
              },
              lua_ls = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = { checkThirdParty = false },
                  telemetry = { enable = false },
                },
              },
              gopls = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                  },
                  staticcheck = true,
                },
              },
              tsgo = {},
              zls = {},
              emmet_language_server = {},
            }

            for name, settings in pairs(server) do
              vim.lsp.config(name, {
                capabilities = capabilities,
                settings = settings,
              })
            end

            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.event:on(
              'confirm_done',
              cmp_autopairs.on_confirm_done()
            )

            local lspkind = require("lspkind")
            lspkind.init({
              mode = "symbol_text",
              preset = "codicons",
              symbol_map = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                  },
              })

            local luasnip = require("luasnip")
            
            -- For future reference: vim.tbl_extend merges to objects and, beacause the first argument
            -- is "keep", it prioritizes the first obeject passed to it, in the event that there is
            -- overlap
            return vim.tbl_extend("keep", {
              formatting = {
                format = lspkind.cmp_format({
                  with_text = true,
                  maxwidth = 60,
                  menu = {
                    buffer = "[﬘]",
                    luasnip = "[]",
                    nvim_lsp = "[]",
                    nvim_lua = "[]",
                    path = "[]",
                    treesitter = "[]",
                    spell = "[󰓆]",
                  },
                }),
              },
              mapping = cmp.mapping.preset.insert {
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<CR>"] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
                },
                ["<C-e>"] = cmp.mapping(function(_)
                  if cmp.visible() then
                    cmp.abort()
                  else
                    cmp.complete()
                  end
                end),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    require("intellitab").indent()
                  end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
              },
              sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1, group_index = 1, keyword_length = 2 },
                { name = "luasnip", keyword_length = 2 , group_index = 2  },
                { name = "treesitter", group_index = 2 , keyword_length = 2},
                { name = "path", group_index = 2, keyword_length = 2 },
              }, {
                { name = "buffer", group_index = 1, keyword_length = 3 },
              }),

              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
            }, opts)
          end
        '';
      }
    ];
  };
}
