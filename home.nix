{ config, pkgs, ... }:

{
  # boiler-plate
  home.username = "kian";
  home.homeDirectory = "/home/kian";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # Sway
  #programs.waybar.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4"; # this sets the mod key to Super
      terminal = "alacritty";
      output = {
        "Virtual-1".resolution = "1920x1080";
      };
      keycodebindings = {
        "$mod+return" = "$term";
      };
      window = {
        titlebar = false;
      };
    };
  };

  # Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 15;
      };
    };
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    l="ls";
    ll="ls -la";
    sys-upgrade="sudo nixos-rebuild switch --upgrade --flake $HOME/nixos-config";
    home-upgrade="home-manager switch --flake $HOME/nixos-config";
    copy="xclip -selection clipboard";
    paste="xlcip -out -selection clipboard";
  };

  programs.git.enable = true;
  programs.git.userName = "KianBahasadri";
  programs.git.userEmail = "101868619+KianBahasadri@users.noreply.github.com";
  programs.gh.enable = true;
}
