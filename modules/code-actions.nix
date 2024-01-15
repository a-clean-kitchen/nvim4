{ pkgs, config, lib, ... }:

let
  cfg = config.vim.lsp;

  inherit (lib) types mkOption mkIf;
in
{
  options.vim.lsp.nvimCodeActionMenu.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable nvim-code-action-menu plugin";
  };

  config = mkIf (cfg.enable && cfg.nvimCodeActionMenu.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-code-action-menu
    ];

    vim.nnoremap = {
      "<silent><leader>ac" = {
        mapping =":CodeActionMenu<CR>";
        description = "Show nvim-code-action-menu";
      };
    };
  };
}
