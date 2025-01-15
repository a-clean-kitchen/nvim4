{ config, lib, pkgs, ... }:

let
  cfg = config.vim.theme;
  
  inherit (lib) mkOption types mkIf;  
  inherit (lib.my) withPlugins writeIf;

  enumb = name: flavors: other:
    if (cfg.name == name) then types.enum flavors else other;
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
  };

  config = mkIf cfg.enable ({
    vim.startPlugins = with pkgs.vimPlugins; (
      (withPlugins (cfg.name == "catppuccin") [ catppuccin ]) ++
      (withPlugins (cfg.name == "everforest") [ everforest ]) ++
      (withPlugins (cfg.name == "rose-pine") [ rose-pine ]) 
    );
    
    vim.startLuaConfigRC = /*lua*/ ''
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

    vim.luaConfigRC = ''
      function readAll(file)
        local f = assert(io.open(file, "rb"))
        local content = f:read("*all")
        f:close()
        return content
      end
      vim.cmd.colorscheme("${cfg.name}")
    '';
  });
}
