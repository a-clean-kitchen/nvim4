{ inputs ? { }, lib, pkgs, ... }:

let
  inherit (lib.nixvim) mkRaw toLuaObject listToUnkeyedAttrs;
in rec {
  trueToString = cond: if cond then "true" else "false";
  writeIf = cond: msg: if cond then msg else "";
  mkListOfAttrs = strings: base: map (name: base.${name}) strings;
  mkLazyKey =
    {
      bind,
      cmd ? null,
      mode ? [ "n" ],
      desc ? null,
      silent ? false
    }:
    let
      posArgs = builtins.filter (x: x != null) [
        bind
        cmd
      ];
    in
    (listToUnkeyedAttrs posArgs) // { inherit mode desc silent; };
  mkLazyKeys = bindings: mkRaw (toLuaObject (map mkLazyKey bindings));
}
