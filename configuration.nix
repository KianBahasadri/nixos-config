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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production; # Latest production driver
  hardware.nvidia.prime = {
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:14:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
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
  services.pulseaudio.enable = false;
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
    dates = "daily";
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
  users.groups.libvirt = {
    name = "libvirt";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 50; # 80 and above it stops charging

    };
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # packages
  environment.systemPackages = with pkgs; [
    # cli tools
    tree
    btop
    fastfetch
    wireguard-tools
    rclone
    wget
    usbutils
    zip
    ranger
    glow
    fdupes
    speedtest-cli
    exiftool
    jq
    file

    # secrets
    age
    age-plugin-yubikey
    yubikey-manager
    sops

    # devtools
    docker-compose
    openssl
    git
    pnpm
    nodejs

    # nix
    nixos-anywhere
    nixos-generators
    nixfmt-rfc-style
    vulnix
    home-manager

    # rust compilation
    cargo
    rustc
    gcc
    pkg-config

    nmap
    lsof
    yt-dlp
    lolcat
    nix-search-cli
    ssh-audit
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
    remmina
    playerctl
    moonlight-qt
    vlc
    feh
    gnome-text-editor
    gedit
    telegram-desktop
    swaybg
    grim
    eog
    gthumb
    imv
    slurp
    spotify
    libreoffice
    zathura
    shotcut
    nautilus
    mullvad-browser
    code-cursor
    vscodium
    vscode
    peek
    obs-studio
    qdirstat
    flameshot
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

  programs.gnupg.agent.enable = true;
  programs.ssh.startAgent = true;
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
