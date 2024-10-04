{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  vim = {
    tsGrammars = [ "rust" ];
    lsp.lspconfigSetup = /*lua*/ ''
      lspconfig.rust_analyzer.setup {
        cmd = { testForLSPBinaryOnPath("rust-analyzer", "${pkgs.rust-analyzer}/bin/rust-analyzer") },
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = false;
            }
          }
        }
      }
    '';
  };
}
