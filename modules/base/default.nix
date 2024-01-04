{ ... }:

{
  imports = [
    ./theme.nix
    ./baseVim.nix
    ./package.nix
    ./lspInit.nix
    ./tsInit.nix
    ./leader.nix
    ./baseVimConfig.nix
  ];
}
