{ config, lib, pkgs, ... }:

let
  cfg = config.vim.luasnip;
  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
  inherit (lib.nixvim.utils) mkRaw;
in {
  options.vim.luasnip = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.luasnip.package;
        name = "luasnip";
        config.__raw = /*lua*/ ''
        function()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { "${ ../snippets }" } })
          do 
            local __luasnip_binds = {
              {
                  action = function()
                      require("luasnip").jump(1)
                  end,
                  key = "<C-L>",
                  mode = { "i", "s" },
                  options = { silent = true },
              },
              {
                  action = function()
                      require("luasnip").jump(-1)
                  end,
                  key = "<C-J>",
                  mode = { "i", "s" },
                  options = { silent = true },
              },
              {
                  action = function()
                      if require("luasnip").choice_active() then
                          require("luasnip").change_choice(1)
                      end
                  end,
                  key = "<C-E>",
                  mode = { "i" },
                  options = { desc = "Change active snippet choice\n", silent = true },
              },
            }
            for i, map in ipairs(__luasnip_binds) do
                vim.keymap.set(map.mode, map.key, map.action, map.options)
            end
          end
        end
        '';
        event = [
          "BufReadPre"
          "BufNewFile"
        ]; 
      }
    ];
  };
}
