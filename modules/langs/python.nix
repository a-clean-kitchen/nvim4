{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.lsp = {
      lspconfigSetup = /*lua*/ ''
        -- Go config
        lspconfig.pylsp.setup {
          cmd = { testForLSPBinaryOnPath("pylsp", "${pkgs.python311Packages.python-lsp-server}/bin/pylsp") }
        }
      '';
    };
  };
}
