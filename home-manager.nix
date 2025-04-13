{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.kian = {
    home.stateVersion = "24.11";
    home.packages = with pkgs; [
    ];

    programs.home-manager.enable = true;

    programs.bash.enable = true;
    programs.bash.shellAliases = {
      l="ls";
      ll="ls -l";
    };

    programs.git.enable = true;
    programs.git.userName = "KianBahasadri";
    programs.git.userEmail = "101868619+KianBahasadri@users.noreply.github.com";
  };
}
