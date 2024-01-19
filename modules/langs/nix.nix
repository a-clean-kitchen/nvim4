{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {

  config = {
    vim.lsp = {
      lspconfigSetup = /*lua*/ ''
        -- Nix config
        lspconfig.nixd.setup{
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = { testForLSPBinaryOnPath("nixd", "${pkgs.nixd}/bin/nixd") }
        }
      '';

    };
  };
}
