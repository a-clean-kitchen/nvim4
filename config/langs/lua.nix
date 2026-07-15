{ config, lib, ... }:

let
  cfg = config.vim.lang.lua;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.lua = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    vim.tsGrammars = [ "lua" ];
    lsp.servers.lua_ls = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        cmd = [ "lua-language-server" ];
        filetypes = [
          "lua"
        ];
        root_markers = [
          "lua_ls_config.json"
          "init.lua"
        ];
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT";
            };
            workspace = {
              checkThirdParty = false;
              library = {
                __unkeyed-1.__raw = "vim.env.VIMRUNTIME";
                __unkeyed-2.__raw = "[vim.fn.expand('$VIMRUNTIME/lua')] = true";
                __unkeyed-3.__raw = "[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true";
              };
            };
            telemetry = {
              enable = false;
            };
            diagnostics = {
              globals = [ "vim" ];
            };
          };
        };
      };
    };
  };
}
