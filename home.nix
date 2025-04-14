{ config, pkgs, ... }:

{
  home.username = "kian";
  home.homeDirectory = "/home/kian";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    l="ls";
    ll="ls -l";
  };

  programs.git.enable = true;
  programs.git.userName = "KianBahasadri";
  programs.git.userEmail = "101868619+KianBahasadri@users.noreply.github.com";
  programs.gh.enable = true;
}
