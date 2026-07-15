{ pkgs, lib, config, ... }:

let
  cfg = config.vim.icons;
  inherit (lib) mkOption types mkIf;

  iconOption = icon: (mkOption {
    type = types.str;
    default = icon;
  });
in {
  options.vim.icons = {
    enable = mkOption {
      type = types.bool;
      default = config.vim.telescope.enable;
    };
    
    extra = {
      oneOff = {
        Codeium = iconOption "";
        Copilot = iconOption "";
        TabNine = iconOption "󰏚";

        Class = iconOption "󰠱";
        Color = iconOption "󰏘";
        Constant = iconOption "󰏿";
        Constructor = iconOption "";
        Enum = iconOption "";
        EnumMember = iconOption "";
        Event = iconOption "";
        Field = iconOption "";
        File = iconOption "󰈙";
        Folder = iconOption "󰉋";
        Function = iconOption "󰊕";
        Interface = iconOption "";
        Keyword = iconOption "󰌋";
        Method = iconOption "";
        Module = iconOption "󰆧";
        Operator = iconOption "󰆕";
        Property = iconOption "󰜢";
        Reference = iconOption "";
        Snippet = iconOption "";
        Text = iconOption "";
        TypeParameter = iconOption "󰗴";
        Unit = iconOption "";
        Value = iconOption "󰎠";

        Array = iconOption "";
        Boolean = iconOption "";
        Collapsed = iconOption "";
        Control = iconOption "";
        Key = iconOption "󰌋";
        Namespace = iconOption "󰦮";
        Null = iconOption "";
        Number = iconOption "󰎠";
        Object = iconOption "";
        Package = iconOption "";
        String = iconOption "";
        Struct = iconOption "󰆼";
        Variable = iconOption "󰀫";
      };
      git = {
        LineAdded = iconOption "";
        LineModified = iconOption "";
        LineRemoved = iconOption "";
        LineLeft = iconOption "▎";
        LineMiddle = iconOption "│";
      };
      ui = {
        Search = iconOption "";
        Selected = iconOption "❯";
        Pointer = iconOption "➜";
        Bug = iconOption "";
        Circle = iconOption "";
        Round = iconOption "";
        Ellipsis = iconOption "";
        Plus = iconOption "";
        Robot = iconOption "󰚩";
        LSP = iconOption "";
        Fold = iconOption "";
        ThinSpace = iconOption " ";
      };
      task = {
        Canceled = iconOption " ";
        Failure = iconOption " ";
        Success = iconOption " ";
        Running = iconOption " ";
      };
      diagnostics = {
        Error = iconOption " ";
        Warning = iconOption " ";
        Info = iconOption " ";
        Hint = iconOption " ";
      };
      spinner = mkOption {
        type = types.listOf types.str;
        default = [ "" "" "" "" "" "" "" "" "" "" "" "" "" ];
      };
    };
  };

  config = mkIf cfg.enable {
    # TODO: Double check that everything that needs this, already ahs it listed in dependencies so i can remove this
    # plugins.lazy.plugins = [
    #   {
    #     pkg = config.plugins.web-devicons.package;
    #     name = "nvim-web-devicons";
    #     opts.__raw = "{}";
    #     event = [ "VeryLazy" ];
    #   }
    # ];
  };
}
