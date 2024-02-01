{ config, lib, pkgs, ... }:

let
  cfg = config.vim.lsp.capabilities;
  
  inherit (lib) mkOption mkIf types;
  inherit (lib.my) vimBindingPre trueToString writeIf;
  inherit (builtins) concatStringsSep;
in
{
  options.vim.lsp.capabilities = {
      luaConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        A string containing the Lua code to be executed to generate the LSP capabilities.
      '';
    };

    formatOnSave = mkOption {
      default = true;
      type = types.bool;
      description = "Enable lspconfig format on save";
    };
  };

  config = {
    vim.lsp.bufKeymapsSetup = let
      defaults = ''
        silent = true
      '';
      method = "vim.api.nvim_buf_set_keymap(bufnr, ";

      mapLSPKeys = vimBindingPre { inherit defaults method; };

      keys = {
        "<leader>lgD" = {
          mapping = "<cmd>lua vim.lsp.buf.declaration()<CR>";
          description = "Goto declaration";
        };
        "<leader>lgd" = {
          mapping = "<cmd>lua vim.lsp.buf.definition()<CR>";
          description = "Goto definition";
        };
        "<leader>lgi" = {
          mapping = "<cmd>lua vim.lsp.buf.implementation()<CR>";
          description = "Goto implementation";
        };
        "<leader>lgr" = {
          mapping = "<cmd>lua vim.lsp.buf.references()<CR>";
          description = "Goto references";
        };
        "<leader>lgt" = {
          mapping = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
          description = "Goto type definition";
        };
        "<leader>lgn" = {
          mapping = "<cmd>lua vim.diagnostic.goto_next()<CR>";
          description = "Goto next diagnostic";
        };
        "<leader>lgp" = {
          mapping = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
          description = "Goto previous diagnostic";
        };
        "<leader>lca" = {
          mapping = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          description = "Code action";
        };
        "<leader>lwa" = {
          mapping = "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>";
          description = "Add workspace folder";
        };
        "<leader>lwr" = {
          mapping = "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>";
          description = "Remove workspace folder";
        };
        "<leader>lwl" = {
          mapping = "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>";
          description = "List workspace folders";
        };
        "<leader>lh" = {
          mapping = "<cmd>lua vim.lsp.buf.hover()<CR>";
          description = "Hover";
        };
        "<leader>lsh" = {
          mapping = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
          description = "Signature help";
        };
        "<leader>ln" = {
          mapping = "<cmd>lua vim.lsp.buf.rename()<CR>";
          description = "Rename";
        };
        "F" = {
          mapping = "<cmd>lua vim.lsp.buf.format { async = true }<CR>";
          description = "Format";
        };
      };
    in /*lua*/ ''
      local attach_keymaps = function(client, bufnr)
        ${concatStringsSep "\n" (mapLSPKeys "nnoremap" keys)}
      end
    '';

    vim.lsp.capabilities.luaConfig = /*lua*/ ''
      vim.g.formatsave = ${
        trueToString cfg.formatOnSave
      }
      -- Enable formatting
      --[[ format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            if vim.g.formatsave then
                local params = require'vim.lsp.util'.make_formatting_params({})
                client.request('textDocument/formatting', params, nil, bufnr)
            end
          end
        })
      end ]]--

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        -- format_callback(client, bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      ${let
        cfg = config.vim.autocomplete;
      in
        writeIf cfg.enable /*lua*/ ''
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        ''
      };

      ${config.vim.lsp.lspconfigSetup}

    '';
  };
}
