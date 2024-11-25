{ pkgs, lib, baseCfg, conf ? {}, ... }:

let
  inherit (lib.my) deepMerge treesitterGrammars;
  inherit (lib) singleton;
  vimfigBuilder = { config }:
    let
      vimOptions = lib.evalModules {
        modules = [
          { imports = [ ./modules ]; }
          config
        ];
        specialArgs = {
          inherit pkgs;
        };
      };

      inherit (vimOptions.config) vim;
      langs = [ "nix" ];
      grammars = pkgs.vimPlugins.nvim-treesitter.builtGrammars;
      treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (treesitterGrammars langs grammars);
      starters = builtins.filter (f: f != null) vim.startPlugins;
    in
    rec {
      # something to point nixd at :)
      theOptions = vimOptions;

      completedPlugins = let 
          starters = builtins.filter (f: f != null) vim.startPlugins;
          ts = singleton (pkgs.vimPlugins.nvim-treesitter.withPlugins 
                (treesitterGrammars
                  vim.tsGrammars
                  pkgs.vimPlugins.nvim-treesitter.builtGrammars));
        in starters ++ ts;

      luaRC = pkgs.writeTextFile {
        name = "init.lua";
        text = ''
          ${vim.luaHelperStuff}
          ${vim.startLuaConfigRC}
          ${vim.luaConfigRC}

          ${vim.finalKeybindings}
        '';
      };

      finalConfigRC = ''
        ${vim.finalConfigRC}

        " Lua configuration
        lua << EOF
        ${luaRC.text}
        EOF
      '';


      neovim = pkgs.wrapNeovim vim.package {
        inherit (vim) viAlias vimAlias;
        configure = {
          customRC = finalConfigRC;

          packages.myVimPackage = {
            start = completedPlugins;
            opt = vim.optPlugins;
          };
        };
      };
    };

  fullConfig = vimfig: deepMerge baseCfg vimfig;
in
{
  full = vimfigBuilder {
    config = fullConfig conf;
  };
}
