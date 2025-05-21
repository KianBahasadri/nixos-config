{
  config,
  pkgs,
  lib,
  ...
}:
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
      defaultWorkspace = "workspace number 1";
      output = {
        "Virtual-1".resolution = "1920x1080";
      };
      keybindings = lib.mkOptionDefault {
        "${modifier}+ctrl+right" = "workspace next";
        "${modifier}+ctrl+left" = "workspace prev";
        "${modifier}+Shift+e" = "exec swaymsg exit";
        "print" = "exec grim";
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
  # i3
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      defaultWorkspace = "workspace number 1";
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
        {
          command = "thunderbird";
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
        "Print" = ''exec import "$HOME/Screenshots/Screenshot_$(date).png"'';
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/gif" = [ "org.gnome.eog.desktop" ]; # replace this with gthumb
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "application/zip" = [ "vim.desktop" ];
        "text/plain" = [ "vim.desktop" ];
        "image/webp" = [ "org.gnome.eog.desktop" ];# replace this with gthumb
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
    configFile."mimeapps.list".force = true;
  };

  gtk = {
    enable = true;
    theme.package = pkgs.arc-theme;
    theme.name = "Arc-Dark";

    iconTheme.package = pkgs.arc-icon-theme;
    iconTheme.name = "Arc";
    gtk3.bookmarks = [ 
      "file:///home/kian/documents"
      "file:///home/kian/personal_media"
      "file:///home/kian/memes"
      "file:///home/kian/temp"
      "file:///home/kian/Screenshots"
    ];
  };

  home.sessionVariables = {
    TERM = "kitty";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
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
      sys-rebuild = "sudo nixos-rebuild switch --flake $HOME/nixos-config";
      home-upgrade = "home-manager switch --flake $HOME/nixos-config";
      openports = "sudo lsof -iTCP -sTCP:LISTEN";
    };
    initExtra = ''
      if [[ $XDG_SESSION_TYPE == Wayland ]] then
        alias copy='wl-copy'
        alias paste='wl-paste'
      elif [[ $XDG_SESSION_TYPE == x11 ]] then
        alias copy='xclip -selection clipboard'
        alias paste='xclip -out -selection clipboard'
      fi
    '';
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
