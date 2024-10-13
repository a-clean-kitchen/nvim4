{ config, lib, pkgs, ... }:

let
  cfg = config.vim;
  
  inherit (lib) 
    mkOption types filterAttrs mapAttrsToList; 

  inherit (lib.my) vimBindingPre mkMappingOption;
  inherit (builtins) concatStringsSep toJSON;
in
{
  options.vim = {
    viAlias = mkOption {
      description = "Enable vi alias";
      type = types.bool;
      default = true;
    };

    vimAlias = mkOption {
      description = "Enable vim alias";
      type = types.bool;
      default = true;
    };

    startConfigRC = mkOption {
      description = "start of vimrc contents";
      type = types.lines;
      default = "";
    };

    finalConfigRC = mkOption {
      description = "built vimrc contents";
      type = types.lines;
      internal = true;
      default = "";
    };

    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    luaHelperStuff = mkOption {
      description = "helper stuff to init at the verrrry beginning";
      type = types.lines;
      default = "";
    };
    
    startLuaConfigRC = mkOption {
      description = "start of vim lua config";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [ ];
      type = with types; listOf (nullOr package);
    };

    tsGrammars = mkOption {
      description = "List of treesitter grammars to load";
      default = [ ];
      type = with types; listOf str;
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [ ];
      type = with types; listOf package;
    };

    globals = mkOption {
      default = { };
      description = "Set containing global variable values";
      type = types.attrs;
    };

    finalKeybindings = mkOption {
      description = "built Keybindings in vimrc contents";
      type = types.lines;
      internal = true;
      default = "";
    };

    nnoremap =
      mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    inoremap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xnoremap =
      mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    snoremap =
      mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cnoremap =
      mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    onoremap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tnoremap =
      mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    nmap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };

    imap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vmap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    xmap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };

    smap = mkMappingOption { description = "Defines 'Select mode' mappings"; };

    cmap =
      mkMappingOption { description = "Defines 'Command-line mode' mappings"; };

    omap = mkMappingOption {
      description = "Defines 'Operator pending mode' mappings";
    };

    tmap =
      mkMappingOption { description = "Defines 'Terminal mode' mappings"; };
  };

  config =
    let
      filterNonNull = filterAttrs (name: value: value != null);
      globalsScript =
        mapAttrsToList (name: value: "let g:${name}=${toJSON value}")
          (filterNonNull cfg.globals);
      mapVimBinding = vimBindingPre {};      

      nmap = mapVimBinding "nmap" config.vim.nmap;
      imap = mapVimBinding "imap" config.vim.imap;
      vmap = mapVimBinding "vmap" config.vim.vmap;
      xmap = mapVimBinding "xmap" config.vim.xmap;
      smap = mapVimBinding "smap" config.vim.smap;
      cmap = mapVimBinding "cmap" config.vim.cmap;
      omap = mapVimBinding "omap" config.vim.omap;
      tmap = mapVimBinding "tmap" config.vim.tmap;

      nnoremap = mapVimBinding "nnoremap" config.vim.nnoremap;
      inoremap = mapVimBinding "inoremap" config.vim.inoremap;
      vnoremap = mapVimBinding "vnoremap" config.vim.vnoremap;
      xnoremap = mapVimBinding "xnoremap" config.vim.xnoremap;
      snoremap = mapVimBinding "snoremap" config.vim.snoremap;
      cnoremap = mapVimBinding "cnoremap" config.vim.cnoremap;
      onoremap = mapVimBinding "onoremap" config.vim.onoremap;
      tnoremap = mapVimBinding "tnoremap" config.vim.tnoremap;
    in
    {
      vim.finalConfigRC = ''
        " Basic configuration
        ${cfg.startConfigRC}

        " Global scripts
        ${concatStringsSep "\n" globalsScript}

         " Config RC
        ${cfg.configRC}
      '';

      vim.finalKeybindings = ''
        ${concatStringsSep "\n" nmap}
        ${concatStringsSep "\n" imap}
        ${concatStringsSep "\n" vmap}
        ${concatStringsSep "\n" xmap}
        ${concatStringsSep "\n" smap}
        ${concatStringsSep "\n" cmap}
        ${concatStringsSep "\n" omap}
        ${concatStringsSep "\n" tmap}
        ${concatStringsSep "\n" nnoremap}
        ${concatStringsSep "\n" inoremap}
        ${concatStringsSep "\n" vnoremap}
        ${concatStringsSep "\n" xnoremap}
        ${concatStringsSep "\n" snoremap}
        ${concatStringsSep "\n" cnoremap}
        ${concatStringsSep "\n" onoremap}
        ${concatStringsSep "\n" tnoremap}
      '';

    };
}
