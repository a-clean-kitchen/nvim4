{ ... }:

{
  imports = [
    ./which-keys.nix
  ];

  config = {
    vim = {
      nmap = {
        "<leader>qq" = {
          mapping = "<cmd>q<CR>";
          description = "Close nvim";
        };
        # buffer management
        "<leader>bk" = {
          mapping = "<cmd>bd<CR>";
          description = "Close buffer";
        };
        "<leader>bp" = {
          mapping = "<cmd>bprevious<CR>";
          description = "Previous Buffer";
        };
        "<leader>bn" = {
          mapping = "<cmd>bnext<CR>";
          description = "Next Buffer";
        };
        "<leader>bf" = {
          mapping = "<cmd>bfirst<CR>";
          description = "First Buffer";
        };
        "<leader>bl" = {
          mapping = "<cmd>blast<CR>";
          description = "Last Buffer";
        };
        "<leader>bw" = {
          mapping = "<cmd>w<CR>";
          description = "Write buffer";
        };

        # window management
        "<leader>ww" = {
          mapping = "<C-W>w";
          description = "Toggle between open windows";
        };
        "<leader>wd" = {
          mapping = "<C-W>c";
          description = "Delete window";
        };
        "<leader>wr" = {
          mapping = "<C-W>r";
          description = "Rotate windows";
        };
        "<leader>wq" = {
          mapping = "<C-W>q";
          description = "Quit window";
        };
        "<leader>wh" = {
          mapping = "<C-W>h";
          description = "Move to the left window";
        };
        "<leader>wl" = {
          mapping = "<C-W>l";
          description = "Move to the right window";
        };
        "<leader>wj" = {
          mapping = "<C-W>j";
          description = "Move to the bottom window";
        };
        "<leader>wk" = {
          mapping = "<C-W>k";
          description = "Move to the top window";
        };
        "<leader>w=" = {
          mapping = "<C-W>=";
          description = "Balance windows";
        };
        "<leader>ws" = {
          mapping = "<C-W>s";
          description = "Split window horizontally";
        };
        "<leader>wv" = {
          mapping = "<C-W>v";
          description = "Split window vertically";
        };
        "<C-Up>" = {
          mapping = "<cmd>resize +2<cr>";
          description = "Increase window height";
        };
        "<C-Down>" = {
          mapping = "<cmd>resize -2<cr>";
          description = "Decrease window height";
        };
        "<C-Left>" = {
          mapping = "<cmd>vertical resize -2<cr>";
          description = "Decrease window width";
        };
        "<C-Right>" = {
          mapping = "<cmd>vertical resize +2<cr>";
          description = "Increase window width";
        };

        # misc
        "<leader>hc" = {
          mapping = "<cmd>noh<CR>";
          description = "Clear hlsearch";
          append = ''
            silent = true,
          '';
        };
      };
    };
  };
}
