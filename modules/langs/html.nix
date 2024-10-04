{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim = {
      tsGrammars = [ "html" ];
      lsp.lspconfigSetup = /*lua*/ ''
        -- HTML config
        lspconfig.emmet_language_server.setup {
          cmd = { testForLSPBinaryOnPath("emmet-language-server", "${pkgs.emmet-language-server}/bin/emmet-language-server"), "--stdio" }
        }
      '';
    };
  };
}
