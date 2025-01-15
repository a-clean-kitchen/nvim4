{ config, lib, pkgs, ... }:

let
  cfg = config.vim.autocomplete;
  snippetOn = config.vim.luasnip.enable;
  
  inherit (lib) mkIf mkOption types;
  inherit (lib.my) withPlugins writeIf indent;
in
{
  options.vim = {
    autocomplete = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable autocomplete";
      };
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.vimPlugins; [
     nvim-cmp
     cmp-buffer
     cmp-nvim-lsp
     cmp-path
     cmp-treesitter
     cmp-cmdline
     lsp-kind
    ] ++ (withPlugins (snippetOn) [ cmp-luasnip ]);
    
    vim.startLuaConfigRC = /*lua*/ ''
      local status, cmp = pcall(require, "cmp")
      if (not status) then return end

      local status, lspkind = pcall(require, "lspkind")
      if (not status) then return end
    '';
 
    vim.luaConfigRC = /*lua*/ ''
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({with_text = true, maxwidth = 50}) 
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), 
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
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
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        })
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    '';
  };
}
