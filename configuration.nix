{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  };

  pnw-cinnamon-theme = pkgs.stdenv.mkDerivation {
    pname = "pnw-cinnamon-theme";
    version = "1.0";
    src = ./home/config/themes/PNW_cinnamon_theme;
    installPhase = ''
      mkdir -p $out/share/themes/PNW_cinnamon_theme
      cp -r . $out/share/themes/PNW_cinnamon_theme/
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Networking
  networking.hostName = "nixkatana";
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Display and Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.displayManager.lightdm.greeters.slick = {
    enable = true;
    draw-user-backgrounds = false;
    theme.name = "PNW_cinnamon_theme";
    theme.package = pnw-cinnamon-theme;
    iconTheme.name = "Gruvbox-Plus-Dark";
    iconTheme.package = pkgs.gruvbox-plus-icons;
    cursorTheme.name = "Nordzy-cursors";
    cursorTheme.package = pkgs.nordzy-cursor-theme;
    cursorTheme.size = 28;
    font.name = "RecMonoLinear Nerd Font";
    font.package = pkgs.nerd-fonts.recursive-mono;
    extraConfig = ''
      background=/home/tonix/Pictures/Wallpapers/gruvbox_nixos_wallpaper.png
      background-color=#282828
      show-hostname=true
      clock-format=%A, %B %e %H:%M:%S
    '';
  };

  # Exclude Cinnamon default apps
  environment.cinnamon.excludePackages = with pkgs; [
    celluloid
    blueman
    gnome-calculator
    gnome-terminal
    xterm
    xed-editor
    xviewer
    xreader
    warpinator
    bulky
    pix
  ];

  # NVIDIA Configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      offload.enable = false;
      reverseSync.enable = false;
      sync.enable = false;
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Graphics - supports both AMD iGPU and NVIDIA dGPU
  hardware.graphics = {
    enable = true;
  };

  # Environment variables
  environment.variables = {
  };

  # Environment session variables
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    # NVIDIA compositor fixes
    __GL_YIELD = "USLEEP";
    __GL_MaxFramesAllowed = "1";
    MUTTER_DEBUG_KMS_THREAD_TYPE = "user"; # dunno if this actually works, muffin -> mutter or something so
  };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Power management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  # Sudo with pwfeedback
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  # User account
  users.users.tonix = {
    isNormalUser = true;
    description = "Tony";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide (required for user shell)
  programs.zsh.enable = true;

  # Storage drive directory structure
  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 tonix users -"
    "d /mnt/storage/SteamLibrary 0755 tonix users -"
    "d /mnt/storage/Games 0755 tonix users -"
    "d /mnt/storage/Mods 0755 tonix users -"
    "d /mnt/storage/Archives 0755 tonix users -"
  ];

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.tonix = import ./home/katana.nix;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit pnw-cinnamon-theme;
    };
  };

  # Steam with NVIDIA support
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override {
      extraEnv = {
        STEAM_FRAME_FORCE_CLOSE = "1";
        STEAM_DISABLE_BROWSER_HW_ACCELERATION = "1";
        __GL_YIELD = "USLEEP";
      };
      extraLibraries = pkgs: with pkgs; [
        libGL
      ];
    };
  };

  # Mullvad VPN
  services.mullvad-vpn.enable = true;

  # Allow unfree packages (required for NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  # Flatpak
  services.flatpak.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Browsers
    librewolf
    brave
    mullvad-browser

    # Development - General
    git
    kdePackages.kate
    claude-code

    # Development - C/C++
    gcc
    clang
    cmake
    gnumake
    gdb
    lldb
    clang-tools
    pkg-config

    # Development - Python
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # Development - Go
    go
    gopls
    delve

    # Development - JVM/Kotlin
    openjdk
    kotlin
    gradle

    # Development - .NET/C#
    (with dotnetCorePackages; combinePackages [
      sdk_8_0
      sdk_9_0
    ])

    # CLI tools
    fastfetch
    tree

    # VPN
    mullvad-vpn

    # Communication
    telegram-desktop
    signal-desktop

    # Media
    vlc
    ffmpeg
    nomacs

    # Office/Productivity
    onlyoffice-desktopeditors
    calibre
    inkscape
    qalculate-gtk

    # Utilities
    rsync
    autorandr
    blueberry
    wget
    curl
    unzip
    htop
    drawio
    system-config-printer

    # Graphics tools
    vulkan-tools
    mesa-demos
    clinfo

    # System diagnostics
    pciutils
    usbutils
    lshw
    dmidecode
    inxi
    file
    lsof
    iotop
    powertop
    smartmontools
    nvme-cli
    strace
    sysstat

    # NVIDIA specific
    nvtopPackages.nvidia
    nvidia-vaapi-driver

    # Themes
    pnw-cinnamon-theme
    gruvbox-plus-icons
    nordzy-cursor-theme
  ];

  # Nerd Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.hack
    nerd-fonts.droid-sans-mono
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.roboto-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.meslo-lg
    nerd-fonts.noto
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.inconsolata
    nerd-fonts.liberation
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.d2coding
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.hurmit
    nerd-fonts.im-writing
    nerd-fonts.intone-mono
    nerd-fonts.lilex
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.monoid
    nerd-fonts.mononoki
    nerd-fonts.open-dyslexic
    nerd-fonts.overpass
    nerd-fonts.profont
    nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono
    nerd-fonts.shure-tech-mono
    nerd-fonts.space-mono
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
    nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
    nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.envy-code-r
    nerd-fonts.hasklug
    nerd-fonts.heavy-data
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.lekton
    nerd-fonts.martian-mono
    nerd-fonts.symbols-only
  ];

  system.stateVersion = "25.11";
}
