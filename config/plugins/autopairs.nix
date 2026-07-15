{ config, lib, pkgs, ... }:

let
  cfg = config.vim.autopairs;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.autopairs = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "A super powerful autopair plugin for Neovim that supports multiple characters";
    };
  };

  config = mkIf cfg.enable {
    extraConfigLuaPre = /*lua*/ ''
      ---Check if entered character matches `end_pair`'s first char.
      ---@param opts cond_opts_pair
      ---@return boolean
      local function char_matches_end_pair(opts)
        return opts.char == opts.next_char:sub(1, 1)
      end

      ---Returns a simple function that checks if cursor is not in a single-line comment.
      ---@param comment_char? string Character used for comments. Default: `#`
      ---@return fun(opts: cond_opts_pair): false? #Autopairs condition
      local function not_in_comment(comment_char)
        local comment = comment_char or "#"
        ---Check if cursor is in single-line comment.
        ---@param opts cond_opts_pair
        ---@return false? #Autopairs condition
        return function(opts)
          if opts.line:sub(1, opts.col):find(comment, 1, true) then
            return false
          end
        end
      end
    '';
    plugins.lazy.plugins = [
      {
        pkg = config.plugins.nvim-autopairs.package;
        name = "nvim-autopairs";
        event = "InsertEnter";
        config.__raw = /*lua*/ ''
        function()
          require("nvim-autopairs").setup({
            disable_filetype = { "TelescopePrompt", "vim", "norg" },
          })
          local Rule = require("nvim-autopairs.rule")
          require("nvim-autopairs").add_rules({
            -- Nix
            Rule("=", ";", "nix")
              :with_pair(not_in_comment())
              :with_pair(require("nvim-autopairs.ts-conds").is_not_in_context())
              :with_pair(require("nvim-autopairs.ts-conds").is_not_ts_node({
                "source",
                "string",
                "indented_string_expression",
                "string_fragment",
              }))
              :with_cr(require("nvim-autopairs.conds").none())
              :with_move(char_matches_end_pair),
            Rule("'", "'", "nix")
              :with_pair(require("nvim-autopairs.conds").not_before_regex("[^%s]"))
              :with_pair(require("nvim-autopairs.conds").not_after_regex([=[[%w%%%'%[%"%.%`%$]]=])) -- Upstream default
              :with_pair(require("nvim-autopairs.ts-conds").is_ts_node({ "indented_string_expression", "string_fragment" }))
              :with_move(require("nvim-autopairs.conds").not_after_text("'''"))
              :with_move(char_matches_end_pair),
            Rule("'''", "'''", "nix")
              :with_pair(not_in_comment())
              :with_pair(require("nvim-autopairs.ts-conds").is_not_in_context())
              :with_pair(require("nvim-autopairs.ts-conds").is_not_ts_node({
                "source",
                "string",
                "indented_string_expression",
                "string_fragment",
              }))
              :with_pair(require("nvim-autopairs.conds").not_before_text("'''"))
                    :with_move(char_matches_end_pair),
            Rule(" ", " ")
              :with_pair(function(opts)
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                  "[]",
                  "()",
                  "{}",
                }, pair)
              end),
          })
        end
        '';
      }
    ];
  };
}
