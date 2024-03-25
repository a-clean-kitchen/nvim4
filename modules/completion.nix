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
    vim.startPlugins = with pkgs.myVimPlugins; [
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
      cmp.setup({
      ${let
          enabled = config.vim.luasnip.enable;
        in 
        indent "  " (writeIf enabled /*lua*/ ''
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
        '')
      }
        formatting = {
          format = lspkind.cmp_format({with_text = true, maxwidth = 50}) 
        },
      })
    '';

#     vim.luaConfigRC = /*lua*/ ''
#       local has_words_before = function()
#           if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
#           local line, col = unpack(vim.api.nvim_win_get_cursor(0))
#         return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
#       end      
# 
#       local feedkey = function(key, mode)
#         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
#       end
# 
#       cmp.setup({
#         snippet = {
#           expand = function(args)
#             vim.fn["vsnip#anonymous"](args.body)
#           end,
#         },
#         sources = cmp.config.sources({
#           { name = 'nvim_lsp' },
#           { name = 'path' },
#           { name = 'treesitter' },
#           { name = 'vsnip' },
#         }, {
#           { name = 'buffer' },
#         }),
#         mapping = {
#           ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
#           ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
#           ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
#           ['<C-y>'] = cmp.config.disable,
#           ['<C-e>'] = cmp.mapping({
#             i = cmp.mapping.abort(),
#             c = cmp.mapping.close(),
#           }),
#           ['<CR>'] = cmp.mapping.confirm({
#             select = true,
#           }),
#           ['<Tab>'] = cmp.mapping(function(fallback)
#             if cmp.visible() then
#               cmp.select_next_item()
#             elseif vim.fn['vsnip#available'](1) == 1 then
#               feedkey("<Plug>(vsnip-expand-or-jump)", "")
#             elseif has_words_before() then
#               cmp.complete()
#             else
#               fallback()
#             end
#           end, { 'i', 's' }),
#       
#           ['<S-Tab>'] = cmp.mapping(function(fallback)
#             if cmp.visible() then
#               cmp.select_prev_item()
#             elseif vim.fn['vsnip#available'](-1) == 1 then
#               feedkeys("<Plug>(vsnip-jump-prev)", "")
#             end
#           end, { 'i', 's' })
#         },
#         formatting = {
#           format = lspkind.cmp_format({with_text = true, maxwidth = 50}) 
#         },
#         completion = {
#           completeopt = 'menu,menuone,noinsert',
#         },
#       }) 
# 
#       cmp.setup.cmdline(':', {
#         mapping = cmp.mapping.preset.cmdline(),
#         sources = cmp.config.sources({
#           { name = 'path' }
#         }, {
#           { name = 'cmdline' }
#         })
#       })
#     '';
  };
}
