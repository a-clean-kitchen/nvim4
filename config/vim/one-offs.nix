{ config, lib, pkgs, ... }:

{
  extraConfigLuaPre = /*lua*/ ''
    -- Test for kitty terminal update padding to use all available real estate :)
    local kittyTest = vim.fn.exepath("kitty")
    if kittyTest ~= "" then
      -- Kitty margin management
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            vim.cmd("silent !kitty @ set-spacing padding-left=0 padding-top=0 padding-right=0 padding-bottom=0")
          end, 100)
        end,
      })

      vim.api.nvim_create_autocmd("VimLeave", {
        callback = function()
          vim.cmd("silent !kitty @ set-spacing default")
        end,
      })
    end
  '';
}
