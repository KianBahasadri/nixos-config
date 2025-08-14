{
  config,
  pkgs,
  lib,
  ...
}:
let
  modifier = "Mod4"; # this sets the mod key to Super
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  # boiler-plate
  home.username = "kian";
  home.homeDirectory = "/home/kian";
  home.stateVersion = "24.11";
  programs.home-manager.enable = false;

  # Sway
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "${modifier}";
      terminal = "alacritty";
      defaultWorkspace = "workspace number 1";
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
          command = "xrandr --auto";
          always = true;
        }
        {
          command = "mpv $HOME/nixos-config/assets/windows_vista_startup.mp3";
          always = true;
        }
        {
          command = "feh --bg-scale $HOME/nixos-config/assets/soldier_wallpaper.jpg";
          always = true;
        }
        {
          command = "thunderbird";
          always = true;
        }
        {
          command = "firefox";
          always = true;
        }
        {
          command = "spotify";
          always = true;
        }
      ];
      assigns = {
        "2" = [ { class = "^firefox$"; } ];
        "6" = [ { class = "Spotify"; } ];
      };
      window = {
        titlebar = false;
      };
      keybindings = lib.mkOptionDefault {
        # the sway syntax doesnt fucking work for i3, >:(
        "${modifier}+Control+Right" = "workspace next";
        "${modifier}+Control+Left" = "workspace prev";
        "${modifier}+Shift+e" = "exec i3-msg exit";
        "F1" = "exec pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo -7%";
        "F2" = "exec pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo +7%";
        "F3" = "exec playerctl play-pause";
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
        "image/webp" = [ "org.gnome.eog.desktop" ]; # replace this with gthumb
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
    TERM = "ansi";
  };
  programs.kitty.environment = {
    "TERM" = "ansi";
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
      home-rebuild = "home-manager switch --flake $HOME/nixos-config";
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

      play_random_ad() {
        if (( RANDOM % 125 == 0 )); then
          ad_dir=~/advertisements
          ad_file=$(find "$ad_dir" -type f | shuf -n 1)
          mpv "$ad_file" --vo=tct --osc=no --no-input-default-bindings \
              --osd-msg1="Your command will run after this short advertisement"
        fi
      }
      trap play_random_ad DEBUG
    '';
  };

  programs.git = {
    enable = true;
    userName = "KianBahasadri";
    userEmail = "101868619+KianBahasadri@users.noreply.github.com";
  };
  programs.gh.enable = true;

  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];

    /* ---- POLICIES ---- */
    # Check about:policies#documentation for options.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      /* ---- EXTENSIONS ---- */
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "myallychou@gmail.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4263531/youtube_recommended_videos-1.6.7.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
 
      };

      /* ---- PREFERENCES ---- */
      # Check about:config for options.
      Preferences = { 
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
    };
  };

  # fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-emoji
    proggyfonts

    #nerdfonts
  ];
}
