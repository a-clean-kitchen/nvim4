{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.lsp = {
      lspconfigSetup = /*lua*/ ''
        -- Go config
        lspconfig.gopls.setup {
          cmd = { testForLSPBinaryOnPath("gopls", "${pkgs.gopls}/bin/gopls") },
          settings = {
            gopls = {
              analyses = {
                unusedparams = true;
              };
              staticcheck = true;
            };
          };
        }
      '';
    };
  };
}
