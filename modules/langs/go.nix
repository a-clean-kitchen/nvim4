{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.lsp = {
      lspconfigSetup = /*lua*/ ''
        -- Go config
        lspconfig.gopls.setup {
          cmd = { "${pkgs.gopls}/bin/gopls" };
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
