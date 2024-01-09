{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.theme;
  
  enumb = name: flavors: other:
    if (cfg.name == name) then types.enum flavors else other;

  inherit (lib.my) withPlugins writeIf;
in
{
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Theme";
    };

    name = mkOption {
      type = types.enum [ "catppuccin" "everforest" "rose-pine" ];
      default = "everforest";
      description = "Theme Name";
    };

    style = mkOption {
      type =
        let
          rp = enumb "rose-pine" [ "main" "moon" "dawn" ];
          ef = enumb "everforest" [ "soft" "medium" "hard" ];
          cp = types.enum [ "frappe" "latte" "macchiato" "mocha" ];
        in
        rp (ef cp);
      description = "Theme Style";
    };

    transparency = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Transparent Background";
    };

  };

  config = mkIf cfg.enable ({
    vim.startPlugins = with pkgs.myVimPlugins; (
      (withPlugins (cfg.name == "catppuccin") [ catppuccin ]) ++
      (withPlugins (cfg.name == "everforest") [ everforest ]) ++
      (withPlugins (cfg.name == "rose-pine") [ rose-pine ]) ++
      (withPlugins (cfg.transparency) [ transparent-nvim ])
    );
    
    vim.startLuaConfigRC = ''
      ${writeIf (cfg.name == "catppuccin") ''
        require("catppuccin").setup({
          flavour = "${cfg.style}",
        })
      ''}

      ${writeIf (cfg.name == "everforest") ''
        require("everforest").setup({
          background = "${cfg.style}",
        })
      ''}

      ${writeIf (cfg.name == "rose-pine") ''
        require("rose-pine").setup({
          variant = "${cfg.style}",
        }) 
      ''}
    '';

    vim.luaConfigRc = /*lua*/ ''
      vim.cmd.colorscheme("${cfg.name}")
    '';
  });
}
