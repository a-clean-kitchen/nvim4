{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim = {
      tsGrammars = [
        "javascript"
        "typescript"
        "tsx"
        "angular"
        "vue"
      ];

      startPlugins = with pkgs.vimPlugins; [
        typescript-tools 
      ];

      startLuaConfigRC = ''
        local status, typescripttools = pcall(require, "typescript-tools")
        if (not status) then return end
      '';

      lsp.lspconfigSetup = ''
        typescripttools.setup {
          on_attach = default_on_attach,
        }
      '';
    };
  };
}
