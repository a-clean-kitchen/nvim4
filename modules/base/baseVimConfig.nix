{ pkgs, lib, config, ... }:

let
  cfg = config.vim;

  inherit (lib) mkOption mkDefault types;
  inherit (lib.my) writeIf trueToString;
in
{
  options.vim = {
    colourTerm = mkOption {
      type = types.bool;
      description = "Set terminal up for 256 colours";
    };

    disableArrows = mkOption {
      type = types.bool;
      description = "Set to prevent arrow keys from moving cursor";
    };

    hideSearchHighlight = mkOption {
      type = types.bool;
      description = "Hide search highlight so it doesn't stay highlighted";
    };

    scrollOffset = mkOption {
      type = types.int;
      description = "Start scrolling this number of lines from the top or bottom of the page.";
    };

    wordWrap = mkOption {
      type = types.bool;
      description = "Enable word wrapping.";
    };

    syntaxHighlighting = mkOption {
      type = types.bool;
      description = "Enable syntax highlighting";
    };

    useSystemClipboard = mkOption {
      type = types.bool;
      description = "Make use of the clipboard for default yank and paste operations. Don't use * and +";
    };

    mouseSupport = mkOption {
      type = with types; enum [ "a" "n" "v" "i" "c" ];
      description = "Set modes for mouse support. a - all, n - normal, v - visual, i - insert, c - command";
    };

    lineNumberMode = mkOption {
      type = with types; enum [ "relative" "number" "relNumber" "none" ];
      description = "How line numbers are displayed. none, relative, number, relNumber";
    };

    preventJunkFiles = mkOption {
      type = types.bool;
      description = "Prevent swapfile, backupfile from being created";
    };

    tabWidth = mkOption {
      type = types.int;
      description = "Set the width of tabs";
    };

    autoIndent = mkOption {
      type = types.bool;
      description = "Enable auto indent";
    };

    cmdHeight = mkOption {
      type = types.int;
      description = "Height of the command pane";
    };

    updateTime = mkOption {
      type = types.int;
      description = "The number of milliseconds till Cursor Hold event is fired";
    };

    showSignColumn = mkOption {
      type = types.bool;
      description = "Show the sign column";
    };

    bell = mkOption {
      type = types.enum [ "none" "visual" "on" ];
      description = "Set how bells are handled. Options: on, visual or none";
    };

    mapTimeout = mkOption {
      type = types.int;
      description = "Timeout in ms that neovim will wait for mapped action to complete";
    };

    splitBelow = mkOption {
      type = types.bool;
      description = "New splits will open below instead of on top";
    };

    splitRight = mkOption {
      type = types.bool;
      description = "New splits will open to the right";
    };

    spellCheck = {
      markdown = mkOption {
        type = types.bool;
        description = "Enables spell-checker on markdown files";
      };
    };

    customPlugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of custom scripts";
    };
  };

  config = {
    vim.colourTerm = mkDefault true;
    vim.disableArrows = mkDefault false;
    vim.hideSearchHighlight = mkDefault false;
    vim.scrollOffset = mkDefault 8;
    vim.wordWrap = mkDefault false;
    vim.syntaxHighlighting = mkDefault true;
    vim.useSystemClipboard = mkDefault true;
    vim.mouseSupport = mkDefault "a";
    vim.lineNumberMode = mkDefault "relNumber";
    vim.preventJunkFiles = mkDefault true;
    vim.tabWidth = mkDefault 2;
    vim.autoIndent = mkDefault true;
    vim.cmdHeight = mkDefault 1;
    vim.updateTime = mkDefault 300;
    vim.showSignColumn = mkDefault true;
    vim.bell = mkDefault "none";
    vim.mapTimeout = mkDefault 500;
    vim.splitBelow = mkDefault true;
    vim.splitRight = mkDefault true;
    vim.spellCheck.markdown = mkDefault true;

    vim.startPlugins = with pkgs.vimPlugins; [ 
      plenary-nvim
    ] ++ cfg.customPlugins;

    vim.nmap =
      if cfg.disableArrows
      then {
        "<up>" = { mapping = "<nop>"; description = "Just clearing up"; };
        "<down>" = { mapping = "<nop>"; description = "Just clearing down"; };
        "<left>" = { mapping = "<nop>"; description = "Just clearing left"; };
        "<right>" = { mapping = "<nop>"; description = "Just clearing right"; }; 
      }
      else { };

    vim.imap =
      if cfg.disableArrows
      then {
        "<up>" = { mapping = "<nop>"; description = "Just clearing up"; };
        "<down>" = { mapping = "<nop>"; description = "Just clearing down"; };
        "<left>" = { mapping = "<nop>"; description = "Just clearing left"; };
        "<right>" = { mapping = "<nop>"; description = "Just clearing right"; };
      }
      else { };

    vim.startLuaConfigRC =  /*lua*/ ''
      local options = {
        encoding = "utf-8",
        mouse = "${cfg.mouseSupport}",
        tabstop = ${toString cfg.tabWidth},
        shiftwidth = ${toString cfg.tabWidth},
        softtabstop = ${toString cfg.tabWidth},
        expandtab = true,
        cmdheight = ${toString cfg.cmdHeight},
        updatetime = ${toString cfg.updateTime},
        tm = ${toString cfg.mapTimeout},
        hidden = true,
        splitbelow = ${trueToString cfg.splitBelow},
        splitright = ${trueToString cfg.splitRight},
        ${writeIf cfg.showSignColumn "signcolumn = \"yes\","}
        autoindent = ${trueToString cfg.autoIndent},
        swapfile = ${trueToString (!cfg.preventJunkFiles)},
        backup = ${trueToString (!cfg.preventJunkFiles)},
        writebackup = ${trueToString (!cfg.preventJunkFiles)},
        visualbell = ${trueToString (!(cfg.bell == "none") || !(cfg.bell == "visual"))},
        errorbells = ${trueToString (!(cfg.bell == "none") || !(cfg.bell == "on"))},
        relativenumber = ${trueToString (cfg.lineNumberMode == "relative" || cfg.lineNumberMode == "relNumber")},
        number = ${trueToString (cfg.lineNumberMode == "number" || cfg.lineNumberMode == "relNumber")},
        wrap = ${trueToString cfg.wordWrap},
        termguicolors = ${trueToString cfg.colourTerm},
        hlsearch = ${trueToString (!cfg.hideSearchHighlight)},
        incsearch = ${trueToString cfg.hideSearchHighlight},

      }
      for k, v in pairs(options) do
        vim.opt[k] = v
      end

      ${writeIf cfg.useSystemClipboard ''
        vim.opt.clipboard:append("unnamedplus")
      ''}

      ${writeIf cfg.syntaxHighlighting ''
        vim.cmd("syntax on")
      ''}

      ${writeIf cfg.spellCheck.markdown ''
        vim.cmd("au BufNewFile,BufRead *.md set spell")
      ''}
    '';
  };
}
