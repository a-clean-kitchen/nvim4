{ config, lib, pkgs, ... }:

let 
  cfg = config.vim.alphastart;
in {
#   config = {
#     vim.startPlugins = with pkgs.myVimPlugins; [
#       dashboard-nvim
#       nvim-web-devicons
#     ];
# 
#     vim.startLuaConfigRC = ''
#       local dashboard = require("dashboard")
#       dashboard.setup({
#         theme = 'doom',
#         config = {
#           week_header = {
#             enable = true,
#           }
#         }
#       })
#     '';
#   };
}
