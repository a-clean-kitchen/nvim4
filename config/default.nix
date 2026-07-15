_: {
  imports = [
    # Everything completion related
    ./cmp

    # LSP stuff and language-specific config
    ./langs
    
    # Base Vim config
    ./vim/keys.nix
    ./vim/leader.nix
    ./vim/one-offs.nix
    ./vim/baseConfig.nix
    ./vim/colorscheme.nix

    # Per-plugin config
    ./plugins/ansi.nix
    ./plugins/lazy.nix
    ./plugins/todo.nix
    ./plugins/icons.nix
    ./plugins/noice.nix
    ./plugins/lualine.nix
    ./plugins/luasnip.nix
    ./plugins/trouble.nix
    ./plugins/gitsigns.nix
    ./plugins/leetcode.nix
    ./plugins/neo-tree.nix
    ./plugins/true-zen.nix
    ./plugins/autopairs.nix
    ./plugins/telescope.nix
    ./plugins/which-key.nix
    ./plugins/treesitter.nix

    # Plugins that truly deserve their own directory
    ./plugins/snacks

    # To be continued...
    # ./plugins/nonsense.nix
    # ./plugins/terminal.nix
  ];
}
