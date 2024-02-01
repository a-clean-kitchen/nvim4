{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.lsp = {
      lspconfigSetup = /*lua*/ ''
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = default_on_attach,
        cmd = { testForLSPBinaryOnPath("lua-language-server", "${pkgs.lua-language-server}/bin/lua-language-server") },
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                  }
                }
              }
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end
      }
      '';
    };
  };
}
