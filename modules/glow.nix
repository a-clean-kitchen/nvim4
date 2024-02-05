{ config, lib, pkgs, ... }:

let 
  cfg = config.vim.glow;
in {
  config = {
    vim.startPlugins = with pkgs.myVimPlugins; [
      glow
    ];

    vim.startLuaConfigRC = ''
      local status, glow = pcall(require, "glow")
      if (not status) then return end

      glow.setup({})
    '';

    vim.luaConfigRC = ''
      vim.api.nvim_create_augroup("Markdown", {
        clear = true,
      })
      vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = "markdown",
        callback = function ()
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>mdp', ':Glow<CR>', { desc = "Glow preview" })
        end
      })
    '';
  };
}
