{ config, lib, pkgs, ... }:

let
  cfg = config.vim.leetcode;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.leetcode = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable leetcode plugin";
    };
  };


  config = mkIf cfg.enable {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        leetcode-nvim
      ];

      startLuaConfigRC = /*lua*/ ''
        local status, leetcode = pcall(require, "leetcode")
        if (not status) then return end
      '';

      luaConfigRC = /*lua*/ ''
        leetcode.setup {
          lang = "golang",
        }

        vim.api.nvim_create_augroup('leetcode', { 
          clear = true
        })

        vim.api.nvim_create_autocmd({'Filetype'}, {
          pattern = "leetcode.nvim",
          callback = function ()
            vim.cmd 'setlocal wrap'
          end
        })
      '';
      nmap = {
        "<leader>lct" = {
          mapping = "<cmd>Leet test<CR>";
          description = "Test leetcode submission";
        };
        "<leader>lcs" = {
          mapping = "<cmd>Leet submit<CR>";
          description = "Submit leetcode submission";
        };
        "<leader>lcl" = {
          mapping = "<cmd>Leet lang<CR>";
          description = "Change leetcode language";
        };
        "<leader>lcLe" = {
          mapping = "<cmd>Leet list difficulty=easy<CR>";
          description = "List easy leetcode questions";
        };
        "<leader>lcLm" = {
          mapping = "<cmd>Leet list difficulty=medium<CR>";
          description = "List medium leetcode questions";
        };
        "<leader>lcLh" = {
          mapping = "<cmd>Leet list difficulty=hard<CR>";
          description = "List hard leetcode questions";
        };
        "<leader>lcLa" = {
          mapping = "<cmd>Leet list<CR>";
          description = "List all leetcode questions";
        };
        "<leader>lcRe" = {
          mapping = "<cmd>Leet random difficulty=easy<CR>";
          description = "Random easy leetcode question";
        };
        "<leader>lcRm" = {
          mapping = "<cmd>Leet random difficulty=medium<CR>";
          description = "Random medium leetcode question";
        };
        "<leader>lcRh" = {
          mapping = "<cmd>Leet random difficulty=hard<CR>";
          description = "Random hard leetcode question";
        };
        "<leader>lcr" = {
          mapping = "<cmd>Leet reset<CR>";
          description = "Reset leetcode code definition";
        };
        "<leader>lcT" = {
          mapping = "<cmd>Leet tabs<CR>";
          description = "Pick leetcode tabs";
        };
        "<leader>lci" = {
          mapping = "<cmd>Leet info<CR>";
          description = "Show leetcode info";
        };
        "<leader>lcc" = {
          mapping = "<cmd>Leet console<CR>";
          description = "Opens console for leetcode question";
        };
      };
    };
  };
}
