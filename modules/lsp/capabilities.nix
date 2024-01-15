{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp.capabilities;
  
  inherit (lib) mkOption mkIf types;
in
{
  options.vim.lsp.capabilities = mkOption {
    type = types.string;
    default = "";
    description = ''
      A string containing the Lua code to be executed to generate the LSP capabilities.
    '';
  };

  config = {
    vim.lsp.capabilities = /*lua*/ ''
      
    '';
  };
}
