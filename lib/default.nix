{ inputs ? { }, lib, pkgs, ... }:

let
  inherit (lib) forEach filterAttrs recursiveUpdate setAttrByPath mapAttrsRecursive;
  inherit (builtins) attrNames elem trace;
in
{
  deepMerge = recursiveUpdate;

  withPlugins = cond: plugins: if cond then plugins else [ ];

  treesitterGrammars = langs: grammars: (p: (forEach langs (x: grammars."${x}")));

  pluginFilter = whole: filter:
    let
      f = xs: filterAttrs (k: v: !elem k xs);
    in
    attrNames (f filter whole);

  writeIf = cond: msg: if cond then msg else "";

  trueToString = cond: if cond then "true" else "false";

  attrTrace = attr: mapAttrsRecursive (path: value: (trace "path ${path} has value ${value}" value )) attr;
}
