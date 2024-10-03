{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim = {
      tsGrammars = [ "python" ];
      lsp.lspconfigSetup = /*lua*/ ''
        -- Python config
        lspconfig.pylsp.setup {
          cmd = { testForLSPBinaryOnPath("pylsp", "${pkgs.python311Packages.python-lsp-server}/bin/pylsp") }
        }
      '';
    };
  };
}
