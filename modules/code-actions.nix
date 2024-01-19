{ pkgs, config, lib, ... }:

let
  cfg = config.vim.lsp;

  inherit (lib) types mkOption mkIf;
in
{
  options.vim.lsp.nvimCodeActionMenu.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Enable actions-preview plugin";
  };

  config = mkIf (cfg.enable && cfg.nvimCodeActionMenu.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      actions-preview-nvim
    ];

    vim.luaConfigRC = ''
      vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
    '';
  };
}
