{
  description = "Neovim Configuration built using Nix";

  outputs = inputs @ { self, nixpkgs, flake-parts, neovim, ... }:
    let
      system = "x86_64-linux";

      # Extend lib with personal functions
      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      plugins = lib.my.pluginFilter inputs [
        "self"
        "nixpkgs"
        "flake-parts"
        "neovim"
        "nixd"
        "nvim-treesitter"
        "flake-compat"
      ];

      # Extend pkgs with personal derivations
      neovimPackageOverlay = self: super: {
        neovim = neovim.packages.${self.system}.neovim;
      };

      pluginOverlay = import ./plugins.nix {
        inherit plugins inputs lib;
      };

      nixdOverlay = self: supper: {
        inherit (inputs.nixd.packages.${self.system}) nixd;
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
      packages."${system}" = {
        default = self.packages."${system}".base;
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
        #  react = nvim4.react.neovim;
      };

      apps = rec {
        default = base;
        base = {
          type = "app";
          program = "${self.packages.default}/bin/nvim";
        };
      };

      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; inherit (self) packages; }; };

      neovimOptions = lib.evalModules {
        modules = [
          { imports = [ ./modules ]; }
        ];
        specialArgs = {
          inherit pkgs;
        };
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

    # For nixd
    flake-compat = {
      url = github:inclyc/flake-compat;
      flake = false;
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
    dashboard-nvim = {
      url = github:nvimdev/dashboard-nvim;
      flake = false;
    };
    
    # ui
    noice-nvim = {
      url = github:folke/noice.nvim;
      flake = false;
    };

    telescope = {
      url = github:nvim-telescope/telescope.nvim;
      flake = false;
    };
    
    actions-preview-nvim = {
      url = github:aznhe21/actions-preview.nvim;
      flake = false;
    };

    lsp-kind = {
      url = github:onsails/lspkind-nvim;
      flake = false;
    };

    # file tree
    neo-tree = {
      url = github:nvim-neo-tree/neo-tree.nvim;
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
    
    everforest = {
      url = github:neanias/everforest-nvim;
      flake = false;
    };

    # focus
    true-zen = {
      url = github:Pocco81/true-zen.nvim;
      flake = false;
    };

    # transparency
    transparent-nvim = {
      url = github:xiyaowong/transparent.nvim;
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

    # completes me
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

    # key binding help
    which-key = {
      url = github:folke/which-key.nvim;
      flake = false;
    };

    # markdown
    glow-nvim = {
      url = github:ellisonleao/glow.nvim;
      flake = false;
    };

    # tablines
    nvim-bufferline = {
      url = github:akinsho/bufferline.nvim;
      flake = false;
    };

    # statuslines
    lualine = {
      url = github:nvim-lualine/lualine.nvim;
      flake = false;
    };
    
    # misc
    cellular-automaton = {
      url = github:Eandrju/cellular-automaton.nvim;
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
    
    nui = {
      url = github:MunifTanjim/nui.nvim;
      flake = false;
    };

    nvim-notify = {
      url = github:rcarriga/nvim-notify;
      flake = false;
    };

    third-image = {
      url = github:3rd/image.nvim;
      flake = false;
    };

    twilight = {
      url = github:folke/twilight.nvim;
      flake = false;
    };
#     gitsigns-nvim = {
#       url = github:lewis6991/gitsigns.nvim;
#       flake = false;
#     };
  };
}
