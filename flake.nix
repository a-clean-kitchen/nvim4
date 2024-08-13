{
  description = "Neovim Configuration built using Nix";

  outputs = inputs @ { self, nixpkgs, neovim, ... }:
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
      };

      apps = rec {
        default = base;
        base = {
          type = "app";
          program = "${self.packages.default}/bin/nvim";
        };
      };

      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; inherit (self) packages; }; };

      neovimOptions = (lib.evalModules {
        modules = [
          { imports = [ ./modules ]; }
        ];
        specialArgs = {
          inherit pkgs;
        };
      }).options // {lib = lib; builtins = builtins;};
    };

  inputs = {
    ######################
    # the not plugins :) #
    ######################

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    nixd.url = github:nix-community/nixd/release/1.2;

    #############################
    # the not flaked plugins :) #
    #############################

    # startup screen
    startup-nvim = {
      url = github:startup-nvim/startup.nvim;
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

    rose-pine = {
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

    # snippets
    luasnip = {
      url = github:L3MON4D3/LuaSnip;
      flake = false;
    };

    vim-react-snippets = {
      url = github:mlaursen/vim-react-snippets;
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

    nvim-lspsaga = {
      url = github:nvimdev/lspsaga.nvim;
      flake = false;
    };

    # completes me
    nvim-cmp = {
      url = github:hrsh7th/nvim-cmp;
      flake = false;
    };

    cmp-luasnip = {
      url = github:saadparwaiz1/cmp_luasnip;
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

    cmp-path = {
      url = github:hrsh7th/cmp-path;
      flake = false;
    };

    cmp-cmdline = {
      url = github:hrsh7th/cmp-cmdline;
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

    # it's not cheating. it's 10x development.
    copilot-lua = {
      url = github:zbirenbaum/copilot.lua;
      flake = false;
    };

    copilot-cmp = {
      url = github:zbirenbaum/copilot-cmp;
      flake = false;
    };

    copilot-lualine = {
      url = github:AndreM222/copilot-lualine;
      flake = false;
    };

    # typescript
    typescript-tools = {
      url = github:pmizio/typescript-tools.nvim;
      flake = false;
    };

    # markdown
    glow = {
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
    
    # auto-pairs
    autopairs = {
      url = github:windwp/nvim-autopairs;
      flake = false;
    };

    # misc
    cellular-automaton = {
      url = github:Eandrju/cellular-automaton.nvim;
      flake = false;
    };
    
    # formatter
    formatter = {
      url = github:mhartington/formatter.nvim;
      flake = false;
    };

    # color previews
    nvim-colorizer = {
      url = github:norcalli/nvim-colorizer.lua;
      flake = false;
    };

    # just dependencies
    plenary-nvim = {
      url = github:nvim-lua/plenary.nvim;
      flake = false;
    };

    null-ls = {
      url = github:jose-elias-alvarez/null-ls.nvim;
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
  };
}
