{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        ts-autotag
      ];

      tsGrammars = [ "html" ];

      startLuaConfigRC = ''
        local status, tsautotag = pcall(require, "nvim-ts-autotag")
        if (not status) then return end
      '';

      lsp.lspconfigSetup = /*lua*/ ''
        -- HTML config
        lspconfig.emmet_language_server.setup {
          cmd = { testForLSPBinaryOnPath("emmet-language-server", "${pkgs.emmet-language-server}/bin/emmet-language-server"), "--stdio" }
        }
        
        tsautotag.setup({
          opts = {
            enable_close_on_slash = true
          }
        })
      '';
    };
  };
}
