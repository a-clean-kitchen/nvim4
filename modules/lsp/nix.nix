{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {

  config = {
    vim.lsp = {
      lspconfigSetup = ''
        -- Nix config
        lspconfig.nixd.setup{
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = {"${pkgs.nixd}/bin/nixd"}
        }
      '';

    };
  };
}
