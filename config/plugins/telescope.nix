{ pkgs, lib, config, ... }:

let
  cfg = config.vim.telescope;
  inherit (lib) mkOption types mkIf;
  inherit (lib) mkLazyKeys;
in {
  options.vim.telescope = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
  
  config = mkIf (cfg.enable || config.vim.snacks.dashboard.enable) {
    dependencies.ripgrep = {
      enable = true;
      packageFallback = true;
    };
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.telescope.package;
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          telescope-fzf-native-nvim
        ];
        name = "telescope";
        event = "VimEnter";
        keys = mkLazyKeys [
          {
            bind = "<leader>ff";
            cmd = "<cmd>Telescope find_files<cr>";
            desc = "Find files";
          }
          {
            bind = "<leader>fg";
            cmd = "<cmd>Telescope live_grep<cr>";
            desc = "Live grep";
          }
          {
            bind = "<leader>fb";
            cmd = "<cmd>Telescope buffers<cr>";
            desc = "List buffers";
          }
          {
            bind = "<leader>fh";
            cmd = "<cmd>Telescope help_tags<cr>";
            desc = "Help Tag Search";
          }
        ];
      }
    ];
    # plugins.telescope = {
    #   enable = true;
    #   extensions = {
    #     fzf-native.enable = true;
    #   };
    #   keymaps = {
    #     "<leader>ff" = {
    #       action = "find_files";
    #       options = {
    #         desc = "Find Files";
    #       };
    #     };
    #     "<leader>fg" = {
    #       action = "live_grep";
    #       options = {
    #         desc = "Live Grep";
    #       };
    #     };
    #     "<leader>fb" = {
    #       action = "buffers";
    #       options = {
    #         desc = "List Buffers";
    #       };
    #     };
    #     "<leader>fh" = {
    #       action = "help_tags";
    #       options = {
    #         desc = "Help Tag Search";
    #       };
    #     };
    #   };
    # };
  };
}
