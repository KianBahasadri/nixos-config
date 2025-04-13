{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.kian = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    home.packages = with pkgs; [
    ];

    programs.home-manager.enable = true;

    programs.bash.enable = true;
    programs.bash.shellAliases = {
      l="ls -l";
    };

    programs.git.enable = true;
    programs.git.userName = "KianBahasadri";
    programs.git.userEmail = "101868619+KianBahasadri@users.noreply.github.com";

    xdg.mimeApps = {
      enable = true;
      
      defaultApplications = {
        "text/html" = "firefox";
        "x-scheme-handler/http" = "firefox";
        "x-scheme-handler/https" = "firefox";
        "x-scheme-handler/about" = "firefox";
        "x-scheme-handler/unknown" = "firefox";
        "application/pdf" = ["org.pwmt.zathura.desktop"];
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = {
      enable = true;

      theme = {
        # package = pkgs.flat-remix-gtk;
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark-B";
      };

      iconTheme = {
        # package = pkgs.gnome.adwaita-icon-theme;
        # name = "Adwaita";
        name = "Tokyonight-Dark";
      };

      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
      };

      font = {
        name = "Sans";
        size = 11;
      };
    };

  };
}
