{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.luaConfigRC = /*lua*/ ''
      -- Zig config
      lspconfig.zls.setup {
          cmd = { testForLSPBinaryOnPath("zls", "${pkgs.zls}/bin/zls") },
      }
    '';
  };
}
