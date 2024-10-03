{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim = {
      tsGrammars = [ "zig" ];
      lsp.lspconfigSetup = /*lua*/ ''
        -- Zig config
        lspconfig.zls.setup {
            cmd = { testForLSPBinaryOnPath("zls", "${pkgs.zls}/bin/zls") },
        }
      '';
    };
  };
}
