{ plugins, inputs, lib  }:

self: super:

# References for this file:
# https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/applications/editors/neovim/build-neovim-plugin.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/applications/editors/vim/plugins/overrides.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/development/lua-modules/overrides.nix

let
  inherit (self.vimUtils) buildVimPlugin;
  inherit (self.neovimUtils) buildNeovimPlugin;
  inherit (lib.attrsets) nameValuePair mapAttrsToList;
  inherit (lib.lists) subtractLists;
  inherit (builtins) listToAttrs throw fetchurl;

  buildPlug = name: buildVimPlugin {
    pname = name;
    version = "master";
    src = builtins.getAttr name inputs;
    dontBuild = true;
  };

  miscPlugins = {
    nvim-cmp = buildNeovimPlugin {
      pname = "nvim-cmp";
      src = inputs.nvim-cmp.outPath;
    };
  }; 

  overrides = {
    autopairs = {
      nvimSkipModule = [
        # Optional completion dependencies
        "nvim-autopairs.completion.cmp"
        "nvim-autopairs.completion.compe"
      ];
    };
    catppuccin = {
      nvimSkipModule = [
        "catppuccin.groups.integrations.noice"
        "catppuccin.groups.integrations.feline"
        "catppuccin.lib.vim.init"
      ];
    };
    cmp-cmdline = {
      checkInputs = with super.vimPlugins; [ nvim-cmp ];
    };
    cmp-luasnip = {
      checkInputs = with super.vimPlugins; [ nvim-cmp ];
      dependencies = with super.vimPlugins; [ luasnip ];
    };
    cmp-path = {
      checkInputs = with super.vimPlugins; [ nvim-cmp ];
    };
    neo-tree = {
      dependencies = with super.vimPlugins; [
        plenary-nvim
        nui-nvim
      ];
      nvimSkipModule = [
        "neo-tree.types.fixes.compat-0.10"
      ];
    };
    noice-nvim = {
      dependencies = with super.vimPlugins; [ nui-nvim ];
    };
    nvim-lspsaga = {
      # Other modules require setup call first
      nvimRequireCheck = "lspsaga";
    };
    nvim-notify = {
      # Optional fzf integration
      nvimSkipModule = "notify.integrations.fzf";
    };
    plenary-nvim = {
      postPatch = ''
        ${self.gnused}/bin/sed -Ei lua/plenary/curl.lua \
            -e 's@(command\s*=\s*")curl(")@\1${self.curl}/bin/curl\2@'
      '';
      nvimSkipModule = [
        "plenary._meta._luassert"
        "plenary.neorocks.init"
      ];
    };
    startup-nvim = {
      dependencies = with super.vimPlugins; [ plenary-nvim ];
    };
    telescope = {
      dependencies = with super.vimPlugins; [ plenary-nvim ];
    };
    third-image = {
      dependencies = with super.vimPlugins; [
        nvim-treesitter
        nvim-treesitter-parsers.markdown_inline
        # nvim-treesitter-parsers.norg
      ];

      # Add magick to package.path
      patches = [ ./patches/image-nvim/magick.patch ];

      postPatch = ''
        substituteInPlace lua/image/magick.lua \
          --replace-fail @nix_magick@ ${super.luajitPackages.magick}
      '';

      nvimSkipModule = [ "minimal-setup" ];
    };
    typescript-tools = {
      dependencies = with super.vimPlugins; [
        nvim-lspconfig
        plenary-nvim
      ];  
    };
    which-key = {
      nvimSkipModule = [ "which-key.docs" ];
    };
    leetcode-nvim = {
      dependencies = with super.vimPlugins; [
        nui-nvim
        plenary-nvim
        telescope-nvim
      ];

      doInstallCheck = true;
      nvimRequireCheck = "leetcode";
    };
  };

  myBasePlugins = (listToAttrs 
      (map (n: nameValuePair n (if (builtins.hasAttr n overrides) then ((buildPlug n).overrideAttrs overrides.${n}) else (buildPlug n))) 
      (subtractLists (mapAttrsToList (name: value: name) miscPlugins) plugins)))
    // miscPlugins;

  vimPlugins = super.vimPlugins // myBasePlugins;
in {
  inherit vimPlugins; 
}
