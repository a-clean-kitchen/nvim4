{ config, lib, pkgs, ... }:

let
  test = true;
  cfg = config.vim.lsp.nix;
in
{
  options.vim.lsp = { };

  config = {
    vim.luaConfigRC = /*lua*/ ''
      -- Nix config
          lspconfig.nixd.setup{
            capabilities = capabilities;
            on_attach = function(client, bufnr)
              attach_keymaps(client, bufnr)
            end,
            cmd = {"${pkgs.nixd}/bin/nixd"}
          }
    '';

    vim.startPlugins = with pkgs.myVimPlugins;
      [ nvim-lspconfig ];
  };
}
