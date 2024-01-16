{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.lsp = {
      lspconfigSetup = /*lua*/ ''
        -- Go config
        lspconfig.gopls.setup {
          cmd = { "${pkgs.go}/bin/gopls" };
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
