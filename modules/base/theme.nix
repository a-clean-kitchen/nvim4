{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.theme;
in
{
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Blue Vim";
    };
  };

  config = mkIf cfg.enable {
    vim.luaConfigRC = ''
      vim.cmd.colorscheme("catppuccin")
      vim.g.catppuccin_flavour = "mocha"
      require("catppuccin").setup({
        transparent_background = "true",
      })
    '';
    vim.startPlugins = with pkgs.myVimPlugins; [
      startup-nvim
      catppuccin
    ];
  };
}
