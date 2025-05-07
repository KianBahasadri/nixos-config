{ config, pkgs, lib, ... }:

let
  modifier = "Mod4"; # this sets the mod key to Super
in
{
  # boiler-plate
  home.username = "kian";
  home.homeDirectory = "/home/kian";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # Sway
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "${modifier}";
      terminal = "alacritty";
      output = {
        "Virtual-1".resolution = "1920x1080";
      };
      keybindings = lib.mkOptionDefault {
        "${modifier}+ctrl+right" = "workspace next";
        "${modifier}+ctrl+left" = "workspace prev";
        "${modifier}+Shift+e" = "exec swaymsg exit";
        "print" = "exec screenshot";
      };
      keycodebindings = {
        # Logitech MX Master 3
        "--whole-window 275" = "workspace prev";
        "--whole-window 276" = "workspace next";
      };
      window = {
        titlebar = false;
      };
      startup = [
        {
          command = "mpv $HOME/nixos-config/assets/windows_vista_startup.mp3";
        }
        {
          command = "swaybg --image $HOME/nixos-config/assets/sway_wallpaper.jpg";
        }
      ];
    };
  };
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        {
          command = "xrandr --output Virtual-1 --mode 1920x1080";
          always = true;
        }
        {
          command = "mpv $HOME/nixos-config/assets/windows_vista_startup.mp3";
          always = true;
        }
        {
          command = "feh --bg-scale $HOME/nixos-config/assets/i3_wallpaper.jpg";
          always = true;
        }
      ];
      window = {
        titlebar = false;
      };
      keybindings = lib.mkOptionDefault {
        # the sway syntax doesnt fucking work for i3, >:(
        "${modifier}+Control+Right" = "workspace next";
        "${modifier}+Control+Left" = "workspace prev";
        "${modifier}+Shift+e" = "exec i3-msg exit";
        "print" = "exec screenshot";
      };

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

  programs.bash = {
    enable = true;
    shellAliases = {
      l = "ls";
      ll = "ls -la";
      sys-upgrade = "sudo nixos-rebuild switch --upgrade --flake $HOME/nixos-config";
      home-upgrade = "home-manager switch --flake $HOME/nixos-config";
    };
    initExtra = "
    if [[ $XDG_SESSION_TYPE == Wayland ]] then
      alias copy='wl-copy'
      alias paste='wl-paste'
      alias take_screenshot='grim'
    elif [[ $XDG_SESSION_TYPE == x11 ]] then
      alias copy='xclip -selection clipboard'
      alias paste='xclip -out -selection clipboard'
      alias take_screenshot='import'
    fi
    ";
  };

  programs.git = {
    enable = true;
    userName = "KianBahasadri";
    userEmail = "101868619+KianBahasadri@users.noreply.github.com";
  };
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
