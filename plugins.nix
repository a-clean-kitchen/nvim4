{ plugins, inputs, lib }:

super: self:

let
  # https://github.com/NixOS/nixpkgs/blob/d2812bd4a867d367225892058d8b6b613dcf70f9/pkgs/applications/editors/vim/plugins/build-vim-plugin.nix
  inherit (self.vimUtils) buildVimPlugin;
  inherit (lib.attrsets) nameValuePair mapAttrsToList;
  inherit (lib.lists) subtractLists;
  inherit (builtins) listToAttrs;

  buildPlug = name: buildVimPlugin {
    pname = name;
    version = "master";
    src = builtins.getAttr name inputs;
    dontBuild = true;
  };

  miscPlugins = { 
#     vim-prettier = buildVimPlugin {
#       pname = "vim-prettier";
#       version = "master";
#       src = builtins.getAttr "vim-prettier" inputs;
#       buildPhase = ''
#         ${self.yarn}/bin/yarn install --frozen-lockfile --production
#       '';
#     };
  };
in
{
  myVimPlugins =
    let
      thePlug = listToAttrs (map (n: nameValuePair n (buildPlug n)) 
        (subtractLists (mapAttrsToList (name: value: name) miscPlugins) plugins));
    in
    thePlug // miscPlugins;
}
