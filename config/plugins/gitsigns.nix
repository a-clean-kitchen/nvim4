{ config, lib, pkgs, ... }:

let
  cfg = config.vim.gitsigns;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.gitsigns = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Deep buffer integration for Git";
    };
  };


  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {

        pkg = config.plugins.gitsigns.package;
        name = "gitsigns";
        event = [
          "BufReadPost"
          "BufNewFile"
        ];
        opts = {
          signcolumn = false;
          numhl = true;
          linehl = false;
          word_diff = false;
          watch_gitdir = {
            interval = 1000;
            follow_files = true;
          };
          attach_to_untracked = true;
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 1000;
            ignore_whitespace = false;
          };
          current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
          sign_priority = 6;
          update_debounce = 100;
          status_formatter.__raw = "nil";
          max_file_length = 40000;
          preview_config = {
            border = "rounded";
            style = "minimal";
            relative = "cursor";
            row = 0;
            col = 1;
          };
        };
      }
    ];
    # plugins.gitsigns = {
    #   enable = cfg.enable;
    #   settings = {
    #     signcolumn = false;
    #     numhl = true;
    #     linehl = false;
    #     word_diff = false;
    #     watch_gitdir = {
    #       interval = 1000;
    #       follow_files = true;
    #     };
    #     attach_to_untracked = true;
    #     current_line_blame = false;
    #     current_line_blame_opts = {
    #       virt_text = true;
    #       virt_text_pos = "eol";
    #       delay = 1000;
    #       ignore_whitespace = false;
    #     };
    #     current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
    #     sign_priority = 6;
    #     update_debounce = 100;
    #     status_formatter = "nil";
    #     max_file_length = 40000;
    #     preview_config = {
    #       border = "rounded";
    #       style = "minimal";
    #       relative = "cursor";
    #       row = 0;
    #       col = 1;
    #     };
    #   };
    # };
  };
}
