{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lang.nix;

  inherit (lib) mkIf mkOption types;
in
{
  options.vim.lang.nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };


  config = mkIf cfg.enable {
    vim.tsGrammars = [ "nix" ];
    lsp.servers = {
      nil_ls = {
        inherit (cfg) enable;
        packageFallback = true;
        config = {
          cmd = [ "nil" ];
          filetypes = [ "nix" ];
          root_markers = [ 
            "flake.nix"
            "default.nix"
          ];
          single_file_support = true;
          settings.__raw = '' {
            ["nil"] = {
              testSetting = 42,
              nix = { flake = { autoArchive = false } },
            },
          }
          '';
          on_init.__raw = /*lua*/ ''
            function(client, _)
              if client.server_capabilities then
                client.server_capabilities.semanticTokensProvider = nil
                client.server_capabilities.completionProvider = nil
              end
            end
          '';
        };
      };
      nixd = {
        inherit (cfg) enable;
        packageFallback = true;
        config = {
          cmd = [ 
            "nixd"
            "--inlay-hints=false"
            "--semantic-tokens=false"
          ];
          filetypes = [ "nix" ];
          root_markers = [ 
            "flake.nix"
            "default.nix"
          ];
          settings.__raw = '' {
            ["nixd"] = {
              nixpkgs = { expr = "import <nixpkgs> { }" },
              formatting = { command = { "${pkgs.nixfmt}/bin/nixfmt" } },
            },
          }
          '';
          on_init.__raw = /*lua*/ ''
            function(client, _)
              if client.server_capabilities then
                -- Disable everything except completionProvider
                client.server_capabilities.hoverProvider = nil
                client.server_capabilities.definitionProvider = nil
                client.server_capabilities.referencesProvider = nil
                client.server_capabilities.declarationProvider = nil
                client.server_capabilities.typeDefinitionProvider = nil
                client.server_capabilities.implementationProvider = nil
                client.server_capabilities.documentFormattingProvider = nil
                client.server_capabilities.documentRangeFormattingProvider = nil
                client.server_capabilities.documentHighlightProvider = nil
                client.server_capabilities.documentSymbolProvider = nil
                client.server_capabilities.workspaceSymbolProvider = nil
                client.server_capabilities.codeActionProvider = nil
                client.server_capabilities.codeLensProvider = nil
                client.server_capabilities.renameProvider = nil
                client.server_capabilities.signatureHelpProvider = nil
                client.server_capabilities.semanticTokensProvider = nil
                client.server_capabilities.inlayHintProvider = nil
                client.server_capabilities.diagnosticProvider = nil
                client.server_capabilities.documentLinkProvider = nil
                client.server_capabilities.foldingRangeProvider = nil
                client.server_capabilities.selectionRangeProvider = nil
                client.server_capabilities.callHierarchyProvider = nil
                client.server_capabilities.typeHierarchyProvider = nil
              end
            end
          '';
          handlers = {
            __unkeyed-1.__raw = ''["textDocument/publishDiagnostics"] = function() end'';
          };
        };
      };
    };
  };
}
