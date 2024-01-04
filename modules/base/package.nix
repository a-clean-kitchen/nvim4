{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.vim.neovim;
in
{
  options.vim.neovim.package = mkOption {
    type = types.package;
    default = pkgs.neovim-unwrapped;
    description = "The NeoVim package to use. Default pkgs.neovim-unwrapped.";
    example = "pkgs.neovim-nightly";
  };


}
