{ config, lib, pkgs, ... }:

let
  cfg = config.vim.nonsense;
in {
  config = {
    vim.startPlugins = with pkgs.vimPlugins; [
      cellular-automaton
    ];
    
    vim.nmap = {
      "<leader>fml" = {
        mapping = "<cmd>CellularAutomaton make_it_rain<CR>";
        description = "Make it rain";
      };
      "<leader>fmL" = {
        mapping = "<cmd>CellularAutomaton game_of_life<CR>";
        description = "Game of life";
      };
    };
  };
}
