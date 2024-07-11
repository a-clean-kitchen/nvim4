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
    };
  

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.myVimPlugins; [
      luasnip
      vim-react-snippets
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, luasnip = pcall(require, "luasnip")
      if (not status) then return end

      local status, reactSnippets = pcall(require, "vim-react-snippets")
      if (not status) then return end
    '';

    vim.luaConfigRC = /*lua*/ ''
      reactSnippets.lazy_load()

      require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "${ ./snippets }" } })

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
