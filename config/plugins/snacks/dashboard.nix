{ config, lib, pkgs, ... }:

let
  cfg = config.vim.snacks.dashboard;

  inherit (lib) mkIf mkOption types optionalAttrs;
  inherit (lib.nixvim) mkRaw;

  newGH = pkgs.buildEnv {
    name = "gh";
    paths = [ pkgs.gh pkgs.gh-notify ];
  };
in
{
  options.vim.snacks.dashboard = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable snacks dashboard";
    };
    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    vim.snacks.dashboard = {
      settings = optionalAttrs cfg.enable {
        enabled = cfg.enable;
        sections = [
          {
            section = "header";
            align = "center";
          }
          {
            section = "terminal";
            cmd = ''${pkgs.chafa}/bin/chafa -p off --speed 0.5 --clear --scale max "${../../assets/celebi.gif}"'';
            indent = 12;
            ttl = 0;
            enable.__raw = ''
              function()
                return vim.fn.executable("chafa") == 1 and vim.fn.environ()["SSH_CLIENT"] == nil
              end
            '';
            height = 20;
            padding = 1;
          }  
          (
            mkRaw /*lua*/ ''    
              function()
                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                  {
                    title = "Notifications",
                    cmd = "${newGH}/bin/gh-notify -s -a -n5",
                    action = function()
                      vim.ui.open("https://github.com/notifications")
                    end,
                    key = "n",
                    icon = " ",
                    height = 5,
                    enabled = true,
                  },
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 10,
                  },
                  {
                    title = "Git Graph",
                    icon = " ",
                    cmd = [[echo -e "$(${pkgs.git-graph}/bin/git-graph --style round --color always --wrap 50 0 8 -f 'oneline')"]],
                    indent = 1,
                    height = 20,
                  },
                }
                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    pane = 2,
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                  }, cmd)
                end, cmds)
              end
            ''
          )
          {
            section = "keys";
          }
          {
            section = "startup";
          }
        ];
        formats = {
          terminal = {
            align = "center";
          };
          keys = {
            height = 10;
          };
        };
        preset = {
          keys = [
            { 
              icon = " ";
              key = "f";
              desc = "Find File";
              action = ":lua require('snacks').dashboard.pick('files')";
            }
            { 
              icon = " ";
              key = "g";
              desc = "Find Text";
              action = ":lua require('snacks').dashboard.pick('live_grep')";
            }
            {
              icon = config.vim.icons.extra.oneOff.Field;
              key = "T";
              desc = "TODOs";
              action = "<cmd>TodoPanel<cr>";
            }
            { 
              icon = "󰒲 ";
              key = "L";
              desc = "Lazy";
              action = ":Lazy";
              enabled.__raw = "package.loaded.lazy ~= nil";
            }
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
          header.__raw = ''[[
          ▄▀▀▄                                            ▄█▄ 
          ▌■▀▐▌ ▄        ▄                               ▐▓█▌ 
  ▄▓▌  ▄▄ ▀■▓▀ ▓▓█░▄▓▄  ▓▓█░▄▓▄    ▄▄█▄▄   ▄▄█▄▄   ▄▄█▄▄ ▀▓▓▌ 
 ██▀  ▐▒▒▌ ▄▄▓▀▒▒ ▀ ▀██ ▒▒ ▀ ▀██  ▓█▀ ▀▓▓ ▓█▀ ▀▓▓ ▓█▀ ▀▓▓▐▒▒▌ 
▐▓▌    ░░▌ ▐▓▓ ░░    ▐▓▌░░    ▐▓▌▐▒▌  ▄▒▀▐▒▌  ▄▒▀▐▒▌  ▄▒▀ ░░▌ 
 ██▄  ▐██   ▒▒▌██▌  ▄██ ██▌  ▄██  ▀░░▀    ▀░░▀    ▀░░▀   ▀▀▀▄ 
  ▀░█▄██▌  ▐░░ ▐██ █░▀  ▐██ █░▀    ▀█▄  ▄  ▀█▄  ▄  ▀█▄  ▄▄█░▄ 
 ▄  ▄██▀   ██▀  ██▄      ██▄          ▀▀      ▀▀      ▀▀  ███▀
█▀███▀     ▀▄    ██▌      ██▌                                 ]]
          '';
        };
      };
    };
  };
}
