{ plugins, inputs, lib }:

super: self:

let
  inherit (self.vimUtils) buildVimPlugin;
  inherit (lib.attrsets) nameValuePair;
  inherit (builtins) listToAttrs;

  buildPlug = name: buildVimPlugin {
    pname = name;
    version = "master";
    src = builtins.getAttr name inputs;
    dontBuild = true;
  };

  miscPlugins = { };
in
{
  myVimPlugins =
    let
      thePlug = listToAttrs (map (n: nameValuePair n (buildPlug n)) plugins);
    in
    thePlug // miscPlugins;
}
