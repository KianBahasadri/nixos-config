{ config, pkgs, lib, ... }:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  # boiler-plate
  home.username = "kian";
  home.homeDirectory = "/home/kian";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # Sway
  programs.waybar.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4"; # this sets the mod key to Super
      terminal = "alacritty";
      bars = [];
      output = {
        "Virtual-1".resolution = "1920x1080";
      };
      keybindings = lib.mkOptionDefault {
        "${modifier}+ctrl+right" = "workspace next";
        "${modifier}+ctrl+left" = "workspace prev";
      };
      window = {
        titlebar = false;
      };
      startup = [
        { command = "mpv $HOME/nixos-config/assets/windows_vista_startup.mp3"; }
      ];
    };
  };

  # Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12;
      };
    };
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    l="ls";
    ll="ls -la";
    sys-upgrade="sudo nixos-rebuild switch --upgrade --flake $HOME/nixos-config";
    home-upgrade="home-manager switch --flake $HOME/nixos-config";
    copy="wl-copy";
    paste="wl-paste";
  };

  programs.git.enable = true;
  programs.git.userName = "KianBahasadri";
  programs.git.userEmail = "101868619+KianBahasadri@users.noreply.github.com";
  programs.gh.enable = true;

  # fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    mplus-outline-fonts.githubRelease
    nerdfonts
    noto-fonts
    noto-fonts-emoji
    proggyfonts
  ];
}
