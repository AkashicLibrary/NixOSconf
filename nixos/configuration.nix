# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, self, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot = { enable = false; };
      grub = {
        enable = true;
        device = "/dev/disk/by-uuid/a42b192b-b02c-4e1f-91f0-0cddc181f65d";
        efiSupport = true;
        theme = "${pkgs.sleek-grub-theme.override { withStyle = "dark"; }}";
        useOSProber = true;
        splashImage = null;
      };
      efi = { canTouchEfiVariables = true; };
    };
  };

  networking = {
    hostName = "cynthicnix"; # Define your hostname.
    networkmanager = { enable = true; };
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Set your time zone.
  time = { timeZone = "Europe/Vienna"; };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
    };
  };

  services = {
    flatpak = { enable = true; };

    emacs = { enable = true; };

    supergfxd = { enable = true; };

    ollama = {
      enable = true;
      acceleration = "cuda";
      home = "/home/cynthia/ollama";
      models = "/home/cynthia/ollama/models";
      sandbox = false;
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland = { enable = true; };
        theme = "catppuccin-mocha";
      };
    };

    desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "at";
        variant = "nodeadkeys";
      };
    };

    printing = { enable = true; };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = { enable = true; };
    };
  };

  # Enable sound with pipewire.
  hardware = {
    pulseaudio = { enable = false; };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting = { enable = true; };
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:35:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  security = { rtkit = { enable = true; }; };

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024;
  }];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      cynthia = {
        isNormalUser = true;
        description = "Cynthia";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs;
          [
            kdePackages.kate
            #  thunderbird
          ];
      };
    };
    defaultUserShell = pkgs.zsh;
  };

  # Install firefox.
  programs = {
    virt-manager = { enable = true; };

    gnupg = { agent = { enable = true; }; };

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

    zsh = { enable = true; };

    java = {
      enable = true;
      package = pkgs.jdk22;
    };

    steam = {
      enable = true;
      remotePlay = { openFirewall = true; };
      dedicatedServer = { openFirewall = true; };
      extest = { enable = true; };
      localNetworkGameTransfers = { openFirewall = true; };
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    firefox = { enable = true; };

    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
        krb5
        polkit
        python3
        libgcc
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        curl
        dbus
        expat
        fontconfig
        freetype
        fuse3
        gdk-pixbuf
        glib
        glibc
        gtk3
        gtk4
        icu
        libGL
        libappindicator-gtk3
        libdrm
        jsoncpp
        libglvnd
        libnotify
        libpulseaudio
        libunwind
        libusb1
        libuuid
        libxkbcommon
        libxml2
        mesa
        nspr
        nss
        openssl
        pango
        pipewire
        stdenv.cc.cc
        systemd
        vulkan-loader
        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.libxkbfile
        xorg.libxshmfence
        zlib
      ];
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      cudaSupport = true;
      allowUnfree = true;
    };
  };

  virtualisation = {
    libvirtd = { enable = true; };

    containers = { enable = true; };

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork = { settings = { dns_enabled = true; }; };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      davinci-resolve
      home-manager
      libtool
      pciutils
      krb5
      wmctrl
      ispell
      mangohud
      discord
      maven
      gnupg
      pass
      git-credential-manager
      prismlauncher
      floorp
      godot_4
      godot_4-export-templates
      jamesdsp
      spotify
      nix-index
      ani-cli
      polkit
      supergfxctl
      libglvnd
      libGL
      gtk3
      gtk4
      zlib-ng
      vivaldi
      hyfetch
      fastfetch
      tree
      unnethack
      oh-my-zsh
      python3
      tree-sitter
      eza
      libgcc
      gcc
      unzip
      lazygit
      distrobox
      podman-tui
      docker-compose
      timeshift
      btop
      obsidian
      lua
      luajit
      texliveFull
      xdotool
      xclip
      nixfmt-classic
      graphviz
      direnv
      dockfmt
      shfmt
      shellcheck
      mu
      isync
      ripgrep
      fd
      imagemagick
      pandoc
      cmake
      gnumake
      wl-clipboard
      virtualenv
      fzf
      zoxide
      git
      nix-your-shell
      jetbrains-toolbox
      tmux
      emacs
      lua
      luajit
      alacritty
      neovim
      catppuccin-sddm
      wget
      emacsPackages.editorconfig
      xorg.xwininfo
      python312Packages.argcomplete
      python312Packages.pygame
      kdePackages.discover
      kdePackages.partitionmanager
      libsForQt5.polonium
    ];

    sessionVariables = { FLAKE = "/config"; };
  };

  fonts = { packages = with pkgs; [ nerdfonts ]; };

  nix = { settings = { experimental-features = [ "nix-command" "flakes" ]; }; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "24.05"; # Did you read the comment?
  };

}
