{ config, lib, pkgs, ... }:

# https://github.com/kawre/leetcode.nvim
let
  cfg = config.vim.leetcode;

  inherit (lib) mkIf mkOption types;
  inherit (lib) mkLazyKeys;
in
{
  options.vim.leetcode = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.which-key.groups = [
      {
        __unkeyed-1 = "<leader>lc";
        group = "leetcode";
      }
    ];
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.leetcode.package;
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          nui-nvim
        ];
        name = "leetcode";
        config.__raw = /*lua*/ ''
          function()
            require('leetcode').setup {
              lang = "golang"
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
          end
        '';
        keys = mkLazyKeys [

          {
						bind = "<leader>lct";
            cmd = "<cmd>Leet test<CR>";
            desc = "Test leetcode submission";
          }
          {
						bind = "<leader>lcs";
            cmd = "<cmd>Leet submit<CR>";
            desc = "Submit leetcode submission";
          }
          {
						bind = "<leader>lcl";
            cmd = "<cmd>Leet lang<CR>";
            desc = "Change leetcode language";
          }
          {
						bind = "<leader>lcLe";
            cmd = "<cmd>Leet list difficulty=easy<CR>";
            desc = "List easy leetcode questions";
          }
          {
						bind = "<leader>lcLm";
            cmd = "<cmd>Leet list difficulty=medium<CR>";
            desc = "List medium leetcode questions";
          }
          {
						bind = "<leader>lcLh";
            cmd = "<cmd>Leet list difficulty=hard<CR>";
            desc = "List hard leetcode questions";
          }
          {
						bind = "<leader>lcLa";
            cmd = "<cmd>Leet list<CR>";
            desc = "List all leetcode questions";
          }
          {
						bind = "<leader>lcRe";
            cmd = "<cmd>Leet random difficulty=easy<CR>";
            desc = "Random easy leetcode question";
          }
          {
						bind = "<leader>lcRm";
            cmd = "<cmd>Leet random difficulty=medium<CR>";
            desc = "Random medium leetcode question";
          }
          {
						bind = "<leader>lcRh";
            cmd = "<cmd>Leet random difficulty=hard<CR>";
            desc = "Random hard leetcode question";
          }
          {
						bind = "<leader>lcr";
            cmd = "<cmd>Leet reset<CR>";
            desc = "Reset leetcode code definition";
          }
          {
						bind = "<leader>lcT";
            cmd = "<cmd>Leet tabs<CR>";
            desc = "Pick leetcode tabs";
          }
          {
						bind = "<leader>lci";
            cmd = "<cmd>Leet info<CR>";
            desc = "Show leetcode info";
          }
          {
						bind = "<leader>lcc";
            cmd = "<cmd>Leet console<CR>";
            desc = "Opens console for leetcode question";
          }
        ];
        cmd = "Leet";
        event = [ "BufRead leetcode.nvim" "BufNewFile leetcode.nvim" ];
      }
    ];

  };
}
