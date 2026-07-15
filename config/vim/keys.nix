{ ... }:

{
  config = {
    keymaps = [
      {
        action = "<cmd>q<CR>";
        mode = [ "n" ];
        key = "<leader>qq";
        options.desc = "Close nvim";
      }
      {
        action = "<cmd>qa<CR>";
        mode = [ "n" ];
        key = "<leader>qa";
        options.desc = "Close all of nvim";
      }
      # Buffer Management
      {
        action = "<cmd>bd<CR>";
        mode = [ "n" ];
        key = "<leader>bk";
        options.desc = "Close buffer";
      }
      {
        action = "<cmd>bprevious<CR>";
        mode = [ "n" ];
        key = "<leader>bp";
        options.desc = "Previous Buffer";
      }
      {
        action = "<cmd>bnext<CR>";
        mode = [ "n" ];
        key = "<leader>bn";
        options.desc = "Next Buffer";
      }
      {
        action = "<cmd>bfirst<CR>";
        mode = [ "n" ];
        key = "<leader>bf";
        options.desc = "First Buffer";
      }
      {
        action = "<cmd>blast<CR>";
        mode = [ "n" ];
        key = "<leader>bl";
        options.desc = "Last Buffer";
      }
      {
        action = "<cmd>w<CR>";
        mode = [ "n" ];
        key = "<leader>bw";
        options.desc = "Write buffer";
      }

      # Window Management
      {
        action = "<C-W>w";
        mode = [ "n" ];
        key = "<leader>ww";
        options.desc = "Toggle between open windows";
      }
      {
        action = "<cmd>close<CR>";
        mode = [ "n" ];
        key = "<leader>wd";
        options.desc = "Delete window";
      }
      {
        action = "<C-W>r";
        mode = [ "n" ];
        key = "<leader>wr";
        options.desc = "Rotate windows";
      }
      {
        action = "<cmd>q<CR>";
        mode = [ "n" ];
        key = "<leader>wq";
        options.desc = "Quit window";
      }
      {
        action = "<C-W>=";
        mode = [ "n" ];
        key = "<leader>w=";
        options.desc = "Balance windows";
      }
      {
        action = "<cmd>split<CR>";
        mode = [ "n" ];
        key = "<leader>ws";
        options.desc = "Split window horizontally";
      }
      {
        action = "<cmd>vsplit<CR>";
        mode = [ "n" ];
        key = "<leader>wv";
        options.desc = "Split window vertically";
      }
      {
        action = "<cmd>resize +2<CR>";
        mode = [ "n" ];
        key = "<C-Up>";
        options.desc = "Increase window height";
      }
      {
        action = "<cmd>resize -2<CR>";
        mode = [ "n" ];
        key = "<C-Down>";
        options.desc = "Decrease window height";
      }
      {
        action = "<cmd>vertical resize +2<CR>";
        mode = [ "n" ];
        key = "<C-Left>";
        options.desc = "Decrease window width";
      }
      {
        action = "<cmd>vertical resize -2<CR>";
        mode = [ "n" ];
        key = "<C-Right>";
        options.desc = "Increase window width";
      }

      # Window navigation
      {
        action = "<C-W>h";
        mode = [ "n" ];
        key = "<leader>wh";
        options.desc = "Move to the left window";
      }
      {
        action = "<C-W>l";
        mode = [ "n" ];
        key = "<leader>wl";
        options.desc = "Move to the right window";
      }
      {
        action = "<C-W>j";
        mode = [ "n" ];
        key = "<leader>wj";
        options.desc = "Move to the bottom window";
      }
      {
        action = "<C-W>k";
        mode = [ "n" ];
        key = "<leader>wk";
        options.desc = "Move to the top window";
      }

      # Misc
      {
        action = "<cmd>noh<CR>";
        mode = [ "n" ];
        key = "<leader>hc";
        options = {
          desc = "Clear hlsearch";
          silent = true;
        };
      }
    ];
  };
}
