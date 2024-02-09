{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      typescript-tools 
    ];
    vim.startLuaConfigRC = ''
      local status, typescripttools = pcall(require, "typescript-tools")
      if (not status) then return end
    '';
    vim.luaConfigRC = ''
      typescripttools.setup {
        on_attach = default_on_attach,
      }
    '';
  };
}
