{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp;

  inherit (lib) mkOption mkIf types;
  inherit (lib.my) mkMappingOption; 
in
{
  imports = [
    ./capabilities.nix
  ];

  options.vim.lsp = {
    enable = mkOption {
      default = true;
      type = types.bool;
      description = "Enable lspconfig";
    };

    folds = mkOption {
      default = true;
      type = types.bool;
      description = "Enable lspconfig folds";
    };

    bufKeymaps = mkMappingOption {
      description = "Keymaps for attached buffers";
    };
    
    bufKeymapsSetup = mkOption {
      default = "";
      type = types.lines;
      description = "Setup keymaps for attached buffers";
    };
    
    lspconfigSetup = mkOption {
      default = "";
      type = types.lines;
      description = ''
        A string containing the Lua code to be executed to setup the lspconfig servers.
      '';
    };

  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.myVimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      ${cfg.bufKeymapsSetup}

      -- Enable lspconfig
      local status, lspconfig = pcall(require, "lspconfig")
      if (not status) then return end
      
      local status, util = pcall(require, "lspconfig.util")
      if (not status) then return end

      local testForLSPBinaryOnPath = function(name, alternate)
        local path = vim.fn.exepath(name)
        if path == "" then
          return alternate
        end
        return path
      end

      ${cfg.capabilities.luaConfig}

    '';
  };
}
