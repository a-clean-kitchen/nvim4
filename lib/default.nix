# Shamelessly stolen from Henrik Lissner's dotfiles.
# They can be found at
# https://https://github.com/hlissner/dotfiles

{ inputs ? { }, lib, pkgs, ... }:

let 
  inherit (lib) forEach filterAttrs recursiveUpdate setAttrByPath;
  inherit (builtins) trace;
in 
{
  deepMerge = recursiveUpdate;

  treesitterGrammars = langs: grammars: (p: (forEach langs (x: grammars."${x}")));

  pluginFilter = whole: filter: let
      f = xs: filterAttrs (k: v: !builtins.elem k xs);
    in
  builtins.attrNames (f filter whole);

  writeIf = cond: msg: if cond then msg else "";
}