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
          cmd = { testForLSPBinaryOnPath("nixd", "${pkgs.nixd}/bin/nixd") },
            filetypes = { 'nix' },
          single_file_support = true,
          root_dir = function(fname)
            return util.root_pattern(unpack { '.nixd.json', 'flake.nix' })(fname) or util.find_git_ancestor(fname)
          end,
        }
      '';

    };
  };
}
