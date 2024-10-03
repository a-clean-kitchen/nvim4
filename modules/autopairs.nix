{ config, lib, pkgs, ... }:

let
  cfg = config.vim.autopairs;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      autopairs
    ];

    vim.startLuaConfigRC = /*lua*/ ''
      local status, autopairs = pcall(require, "nvim-autopairs")
      if (not status) then return end

      local status, APRule = pcall(require, "nvim-autopairs.rule")
      if (not status) then return end

      local status, APcond = pcall(require, "nvim-autopairs.conds")
      if (not status) then return end
    '';
    
    vim.luaConfigRC = /*lua*/ ''
      autopairs.setup({
        disable_filetype = { "TelescopePrompt" , "vim" },
      })
      --[[
      autopairs.add_rules({
        APRule("=", "")
          :with_pair(APcond.not_inside_quote())
          :with_pair(function(opts)
              local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
              if last_char:match("[%w%=%s]") then
                  return true
              end
              return false
          end)
          :replace_endpair(function(opts)
              local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
              local next_char = opts.line:sub(opts.col, opts.col)
              next_char = next_char == " " and "" or " "
              if prev_2char:match("%w$") then
                  return "<bs> =" .. next_char
              end
              if prev_2char:match("%=$") then
                  return next_char
              end
              if prev_2char:match("=") then
                  return "<bs><bs>=" .. next_char
              end
              return ""
          end)
          :set_end_pair_length(0)
          :with_move(APcond.none())
          :with_del(APcond.none())
      })
      ]]
    '';
  };
}
