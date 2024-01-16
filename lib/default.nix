{ inputs ? { }, lib, pkgs, ... }:

let
  inherit (lib) 
    forEach filterAttrs recursiveUpdate setAttrByPath 
    mapAttrsRecursive mapAttrsToList hasAttr hasSuffix
    mkOption types;
  inherit (builtins) attrNames elem trace substring;
in rec {
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

  vimBindingPre = { defaults ? "", method ? "vim.keymap.set(" }: prefix: keymapAttrs: forEach (mapAttrsToList (name: value: { inherit name; } // value) keymapAttrs) (value: ''
    ${method}"${substring 0 1 prefix}", "${value.name}", "${value.mapping}", {
      noremap = ${trueToString (hasSuffix "noremap" prefix)},
      ${if (substring 0 1 prefix) == "n" then "desc = \"${value.description}\"," else ""}
      ${if hasAttr "append" value then value.append else ""}
      ${defaults}
    })  
  '');
  
  mkMappingOption = it:
    mkOption ({
      default = { };
      type = with types; attrsOf (nullOr (attrsOf (str)));
    } // it);
}
