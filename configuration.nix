# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  remote_desktop = false;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    videoDrivers = [ "qxl" ];
  };

  # greeters
  #services.displayManager.sddm.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-session --theme 'Aardvark Blue' --cmd i3";
        user = "greeter";
      };
    };
  };

  # https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # DEs and WMs
  #services.desktopManager.plasma6.enable = true;
  programs.sway.enable = true;
  services.xserver = {
    displayManager.startx.enable = true;
    windowManager.i3 = {
      enable = true;
    };
  };

  environment.sessionVariables = {
  TERMINAL = "kitty";
  TERM = "kitty";
  EDITOR = "vim";
};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Nix store management
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 21d";
    dates = "weekly";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kian = {
    isNormalUser = true;
    description = "kian";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirt"
    ];
  };
  users.groups.libvirt= {
    name = "libvirt";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # packages
  environment.systemPackages = with pkgs; [
    # cli tools
    tree
    btop
    rclone
    age
    age-plugin-yubikey
    yubikey-manager
    wget
    docker-compose
    usbutils
    nixos-anywhere
    zip
    ranger
    git
    glow
    fdupes
    speedtest-cli
    exiftool
    nixfmt-rfc-style
    sops
    nmap
    lsof
    yt-dlp
    lolcat
    nix-search-cli
    ssh-audit
    gnome-text-editor
    gedit
    unzip
    imagemagick
    ffmpeg
    dig
    whois
    ((vim_configurable.override { }).customize {
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-nix
          vim-lastplace
        ];
        opt = [ ];
      };
      vimrcConfig.customRC = ''
        syntax on
        set number
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smarttab
        set autoindent
        " ...
      '';
    })
    # desktop applications
    signal-desktop
    bitwarden-desktop
    thunderbird
    gnome-disk-utility
    mpv
    moonlight-qt
    vlc
    feh
    swaybg
    grim
    eog
    gthumb
    imv
    slurp
    libreoffice
    zathura
    shotcut
    nautilus
    mullvad-browser
    code-cursor
    vscodium
    peek
    obs-studio
    qdirstat
    alacritty
    kitty
    xclip
    wl-clipboard
    gimp3
    brave
    (python312.withPackages (
      ps: with ps; [
        numpy # these two are
        scipy # probably redundant to pandas
        jupyterlab
        notebook
        pandas
        statsmodels
        scikitlearn
      ]
    ))
  ];

  services.tumbler.enable = true;
  programs.thunar.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;

  services.pcscd.enable = true;

  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = remote_desktop;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  services.sunshine = {
    enable = remote_desktop;
    autoStart = remote_desktop;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
