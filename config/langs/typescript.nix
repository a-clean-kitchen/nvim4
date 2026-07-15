{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.typescript;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.typescript = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [
      "javascript"
      "typescript"
      "tsx"
      "angular"
      "vue"
    ];
    lsp.servers.tsgo = {
      inherit (cfg) enable;
      packageFallback = true;
      config = {
        cmd = [ "tsgo" ];
        filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
        ];
        root_markers = [
          "package-lock.json"
          "yarn.lock"
          "pnpm-lock.yaml"
          "bun.lockb"
          "bun.lock"
        ];
        settings = {
          typescript = {
            inlayHints = {
              enumMemberValues.enabled = true;
              functionLikeReturnTypes.enabled = false;
              parameterNames = {
                enabled = "literals";
                suppressWhenArgumentMatchesName = true;
              };
              parameterTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled = false;
            };
          };
        };
      };
    };
  };
}
