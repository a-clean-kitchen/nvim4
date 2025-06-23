{ config, lib, pkgs, ... }:

let
  cfg = config.vim.windsurf;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.windsurf = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable windsurf llm assistance";
    };
  };


  config = mkIf cfg.enable {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        windsurf-nvim
      ];

      startLuaConfigRC = /*lua*/ ''
        local status, _ = pcall(require, "codeium")
        if (not status) then return end
      '';

      luaConfigRC = /*lua*/ ''
        require("codeium").setup({})
      '';

      nmap = {
        "<leader>llc" = {
          mapping = "<cmd>Codeium Chat<CR>";
          description = "Open Codeium Chat";
        };
      };
      
    };
  };
}
