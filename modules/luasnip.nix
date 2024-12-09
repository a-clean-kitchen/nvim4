{ config, lib, pkgs, ... }:

let
  cfg = config.vim.luasnip;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.luasnip = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable luasnip";
    };
    snipConfig = mkOption {
      type = types.lines;
      default = "";

    };
  };
  

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.myVimPlugins; [
      luasnip
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, luasnip = pcall(require, "luasnip")
      if (not status) then return end
    '';

    vim.luaConfigRC = /*lua*/ ''
      require("luasnip.loaders.from_vscode").load({ paths = { "${ ./snippets }" } })

      vim.keymap.set({"i"}, "<C-K>", function() luasnip.expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() luasnip.jump( 1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(-1) end, {silent = true})

      vim.keymap.set({"i", "s"}, "<C-E>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, {silent = true})
    '';
  };
}
