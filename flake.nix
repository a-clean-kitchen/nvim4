{
  description = "Neovim Configuration built using Nix";

  outputs = inputs @ { self, nixpkgs, flake-parts, neovim, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }:
        let
          # Extend lib with personal functions
          lib = nixpkgs.lib.extend
            (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

          inherit (lib.my) pluginFilter;

          plugins = pluginFilter inputs [
                "self"
                "nixpkgs"
                "flake-parts"
                "neovim"
                "nixd"
                "nvim-treesitter"
          ];

          # Extend pkgs with personal derivations
          neovimPackageOverlay = self: super: {
            neovim = neovim.packages.${self.system}.neovim;
          };

          pluginOverlay = import ./plugins.nix {
            inherit plugins inputs lib;
          };

          nixdOverlay = self: supper: {
            inherit (inputs.nixd.packages.${system}) nixd;
          };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ neovimPackageOverlay pluginOverlay nixdOverlay ];
          };

          # The base configuration of all neovim bundles
          baseCfg = import ./base { };

          nvim4 = pkgs.callPackage ./pkg.nix {
            inherit lib pkgs baseCfg;
          };

        in
        {
          packages = {
            default = self'.packages.base;
            base = nvim4.full.neovim;
            # .-. .-')                    .-') _  _ .-') _               ('-.    .-')    
            # \  ( OO )                  ( OO ) )( (  OO) )            _(  OO)  ( OO ).  
            #  ;-----.\  ,--. ,--.   ,--./ ,--,'  \     .'_  ,--.     (,------.(_)---\_) 
            #  | .-.  |  |  | |  |   |   \ |  |\  ,`'--..._) |  |.-')  |  .---'/    _ |  
            #  | '-' /_) |  | | .-') |    \|  | ) |  |  \  ' |  | OO ) |  |    \  :` `.  
            #  | .-. `.  |  |_|( OO )|  .     |/  |  |   ' | |  |`-' |(|  '--.  '..`''.) 
            #  | |  \  | |  | | `-' /|  |\    |   |  |   / :(|  '---.' |  .--' .-._)   \ 
            #  | '--'  /('  '-'(_.-' |  | \   |   |  '--'  / |      |  |  `---.\       / 
            #  `------'   `-----'    `--'  `--'   `-------'  `------'  `------' `-----'  
            #  
            #  go = nvim4.go.neovim;
          };

          apps = rec {
            default = base;
            base = {
              type = "app";
              program = "${self'.packages.default}/bin/nvim";
            };
          };

          devShells = { default = import ./shell.nix { inherit pkgs; inherit (self') packages; }; };
        };
    };

  inputs = {
    ######################
    # the not plugins :) #
    ######################

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #########################
    # the flaked plugins :) #
    #########################

    # nix lsp support
    nixd.url = github:nix-community/nixd;

    #############################
    # the not flaked plugins :) #
    #############################

    # startup screen
    startup-nvim = {
      url = github:startup-nvim/startup.nvim;
      flake = false;
    };

    # themes
    catppuccin = {
      url = github:catppuccin/nvim;
      flake = false;
    };

    rosepine = {
      url = github:rose-pine/neovim;
      flake = false;
    };

    # Neovim LSP everything
    nvim-lspconfig = {
      url = github:neovim/nvim-lspconfig;
      flake = false;
    };

    nvim-treesitter = {
      url = github:nvim-treesitter/nvim-treesitter;
      flake = false;
    };

    # Autocompletes
    nvim-cmp = {
      url = github:hrsh7th/nvim-cmp;
      flake = false;
    };

    cmp-buffer = {
      url = github:hrsh7th/cmp-buffer;
      flake = false;
    };

    cmp-nvim-lsp = {
      url = github:hrsh7th/cmp-nvim-lsp;
      flake = false;
    };

    cmp-vsnip = {
      url = github:hrsh7th/cmp-vsnip;
      flake = false;
    };

    cmp-path = {
      url = github:hrsh7th/cmp-path;
      flake = false;
    };

    cmp-treesitter = {
      url = github:ray-x/cmp-treesitter;
      flake = false;
    };

    # startup screen
    dashboard-nvim = {
      url = github:nvimdev/dashboard-nvim;
      flake = false;
    };

    # Key binding help
    which-key = {
      url = github:folke/which-key.nvim;
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = github:ellisonleao/glow.nvim;
      flake = false;
    };

    # Filetrees
    nvim-tree-lua = {
      url = github:kyazdani42/nvim-tree.lua;
      flake = false;
    };

    # Tablines
    nvim-bufferline = {
      url = github:akinsho/bufferline.nvim;
      flake = false;
    };

    # Statuslines
    lualine = {
      url = github:hoob3rt/lualine.nvim;
      flake = false;
    };

    # just dependencies
    plenary-nvim = {
      url = github:nvim-lua/plenary.nvim;
      flake = false;
    };

    nvim-web-devicons = {
      url = github:nvim-tree/nvim-web-devicons;
      flake = false;
    };

    gitsigns-nvim = {
      url = github:lewis6991/gitsigns.nvim;
      flake = false;
    };
  };
}
