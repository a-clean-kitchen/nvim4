{ config, lib, pkgs, ... }:

let
  cfg = config.vim.todo;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.todo = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.todo-comments.package;
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          fzf-lua
        ];
        name = "todo-comments";
        event = [ "VeryLazy" ];
        opts.__raw = "{}";
        keys = [];
      }
    ];
  };
}
