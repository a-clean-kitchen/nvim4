{ pkgs, lib, config, ... }:

let
  cfg = config.vim;
  inherit (lib) mkOption mkDefault types;
  inherit (lib) writeIf trueToString;
in
{
  options.vim = {
    colourTerm = mkOption {
      type = types.bool;
      description = "Set terminal up for 256 colours";
      default = true;
    };

    disableArrows = mkOption {
      type = types.bool;
      description = "Set to prevent arrow keys from moving cursor";
      default = false;
    };

    hideSearchHighlight = mkOption {
      type = types.bool;
      description = "Hide search highlight so it doesn't stay highlighted";
      default = false;
    };

    scrollOffset = mkOption {
      type = types.int;
      description = "Start scrolling this number of lines from the top or bottom of the page.";
      default = 8;
    };

    wordWrap = mkOption {
      type = types.bool;
      description = "Enable word wrapping.";
      default = false;
    };

    syntaxHighlighting = mkOption {
      type = types.bool;
      description = "Enable syntax highlighting";
      default = true;
    };

    useSystemClipboard = mkOption {
      type = types.bool;
      description = "Make use of the clipboard for default yank and paste operations. Don't use * and +";
      default = true;
    };

    mouseSupport = mkOption {
      type = with types; enum [ "a" "n" "v" "i" "c" ];
      description = "Set modes for mouse support. a - all, n - normal, v - visual, i - insert, c - command";
      default = "a";
    };

    lineNumberMode = mkOption {
      type = with types; enum [ "relative" "number" "relNumber" "none" ];
      description = "How line numbers are displayed. none, relative, number, relNumber";
      default = "relNumber";
    };

    preventJunkFiles = mkOption {
      type = types.bool;
      description = "Prevent swapfile, backupfile from being created";
      default = true;
    };

    tabWidth = mkOption {
      type = types.int;
      description = "Set the width of tabs";
      default = 2;
    };

    autoIndent = mkOption {
      type = types.bool;
      description = "Enable auto indent";
      default = true;
    };

    cmdHeight = mkOption {
      type = types.int;
      description = "Height of the command pane";
      default = 1;
    };

    updateTime = mkOption {
      type = types.int;
      description = "The number of milliseconds till Cursor Hold event is fired";
      default = 300;
    };

    showSignColumn = mkOption {
      type = types.bool;
      description = "Show the sign column";
      default = true;
    };

    bell = mkOption {
      type = types.enum [ "none" "visual" "on" ];
      description = "Set how bells are handled. Options: on, visual or none";
      default = "none";
    };

    mapTimeout = mkOption {
      type = types.int;
      description = "Timeout in ms that neovim will wait for mapped action to complete";
      default = 500;
    };

    splitBelow = mkOption {
      type = types.bool;
      description = "New splits will open below instead of on top";
      default = true;
    };

    splitRight = mkOption {
      type = types.bool;
      description = "New splits will open to the right";
      default = true;
    };

    spellCheck = {
      markdown = mkOption {
        type = types.bool;
        description = "Enables spell-checker on markdown files";
        default = true;
      };
    };

    customPlugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of custom scripts";
    };
  };
  config = {
    opts = {
      encoding = "utf-8";
      mouse = "${cfg.mouseSupport}";
      tabstop = cfg.tabWidth;
      shiftwidth = cfg.tabWidth;
      softtabstop = cfg.tabWidth;
      expandtab = true;
      cmdheight = cfg.cmdHeight;
      updatetime = cfg.updateTime;
      tm = cfg.mapTimeout;
      hidden = true;
      splitbelow = cfg.splitBelow;
      splitright = cfg.splitRight;
      signcolumn = "${if cfg.showSignColumn then "yes" else "no"}";
      autoindent = cfg.autoIndent;
      swapfile = !cfg.preventJunkFiles;
      backup = !cfg.preventJunkFiles;
      writebackup = !cfg.preventJunkFiles;
      visualbell = !(cfg.bell == "none") || !(cfg.bell == "visual");
      errorbells = !(cfg.bell == "none") || !(cfg.bell == "on");
      relativenumber = cfg.lineNumberMode == "relative" || cfg.lineNumberMode == "relNumber";
      number = cfg.lineNumberMode == "number" || cfg.lineNumberMode == "relNumber";
      wrap = cfg.wordWrap;
      termguicolors = cfg.colourTerm;
      hlsearch = !cfg.hideSearchHighlight;
      incsearch = cfg.hideSearchHighlight;
    };

    extraConfigLua = ''
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

    keymaps = if cfg.disableArrows then [
      {
        action = "<nop>";
        mode = [ "n" "i" ];
        key = "<up>";
      }
      {
        action = "<nop>";
        mode = [ "n" "i" ];
        key = "<down>";
      }
      {
        action = "<nop>";
        mode = [ "n" "i" ];
        key = "<left>";
      }
      {
        action = "<nop>";
        mode = [ "n" "i" ];
        key = "<right>";
      }
    ] else [];
  };
}
