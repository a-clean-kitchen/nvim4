{ config, lib, ... }:

let
  inherit (lib) mkOption  types;


  colorOption = icon: (mkOption {
    type = types.str;
    default = icon;
  });
in {
  options.vim = {
    colorscheme = mkOption {
      type = types.str;
      description = "name of colorscheme option in nixvim";
      default = "catppuccin";
    };
    colors = {
      catppuccin = {
        mocha = {
          rosewater = colorOption "#f5e0dc";
          flamingo = colorOption "#f2cdcd";
          pink = colorOption "#f5c2e7";
          mauve = colorOption "#cba6f7";
          red = colorOption "#f38ba8";
          maroon = colorOption "#eba0ac";
          peach = colorOption "#fab387";
          yellow = colorOption "#f9e2af";
          green = colorOption "#a6e3a1";
          teal = colorOption "#94e2d5";
          sky = colorOption "#89dceb";
          sapphire = colorOption "#74c7ec";
          blue = colorOption "#89b4fa";
          lavender = colorOption "#b4befe";
          text = colorOption "#cdd6f4";
          subtext1 = colorOption "#bac2de";
          subtext0 = colorOption "#a6adc8";
          overlay2 = colorOption "#9399b2";
          overlay1 = colorOption "#7f849c";
          overlay0 = colorOption "#6c7086";
          surface2 = colorOption "#585b70";
          surface1 = colorOption "#45475a";
          surface0 = colorOption "#313244";
          base = colorOption "#1e1e2e";
          mantle = colorOption "#181825";
          crust = colorOption "#11111b";
        };
      };
    };
  };

  config = {
    colorschemes."${config.vim.colorscheme}" = {
      enable = true;
    };
  };
}
