{ config, lib, pkgs, ... }:

let
  cfg = config.vim.package;

  inherit (lib) mkOption types;
in
{
  options.vim.package = mkOption {
    type = types.package;
    default = pkgs.neovim-unwrapped;
    description = "The NeoVim package to use. Default pkgs.neovim-unwrapped.";
    example = "pkgs.neovim-nightly";
  };
}
