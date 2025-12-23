{ config, pkgs, pnw-cinnamon-theme, lib,  ... }:
let
  cursorSize = 28;
in
{
  home.username = "tonix";
  home.homeDirectory = "/home/tonix";
  home.stateVersion = "25.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "PNW_cinnamon_theme";
      package = pnw-cinnamon-theme;
    };
    font = {
    name = "CaskaydiaCove Nerd Font";
    size = 10;
    };
    iconTheme = {
    name = "Gruvbox-Plus-Dark";
    package = pkgs.gruvbox-plus-icons;
    };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = cursorSize;
    };
    gtk2.configLocation = "${config.home.homeDirectory}/.gtkrc-2.0";
  };

  # Qt theming - use Kvantum
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Cinnamon/dconf settings
  dconf.settings = {
    "org/cinnamon/muffin" = {
      unredirect-fullscreen-windows = true;
    };
    "org/cinnamon/theme" = {
      name = "PNW_cinnamon_theme";
    };
    "org/cinnamon/desktop/wm/preferences" = {
      theme = "PNW_cinnamon_theme";
      titlebar-font = "CaskaydiaCove Nerd Font Bold 10";
    };
    "org/cinnamon/desktop/interface" = {
      gtk-theme = "PNW_cinnamon_theme";
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Nordzy-cursors";
      clock-show-date = true;
      clock-show-seconds = true;
      cursor-size = cursorSize;
      font-name = "CaskaydiaCove Nerd Font 10";
    };
    "org/cinnamon/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;  # Never blank
    };
    "org/cinnamon/settings-daemon/plugins/power" = {
      sleep-display-ac = 0;  # Never sleep display on AC
      idle-dim-time = 0;
    };

    # Mouse & touchpad
    "org/cinnamon/desktop/peripherals/mouse" = {
      double-click = 198;
      drag-threshold = 8;
      speed = 0.0;
    };
    "org/cinnamon/desktop/peripherals/touchpad" = {
      send-events = "disabled-on-external-mouse";
      speed = 0.0;
    };

    # Media handling
    "org/cinnamon/desktop/media-handling" = {
      autorun-never = false;
      autorun-x-content-ignore = [];
      autorun-x-content-open-folder = ["x-content/ebook-reader"];
      autorun-x-content-start-app = [];
    };

    "org/cinnamon/desktop/applications/terminal" = {
      exec = "kitty";
    };

    # Keybindings
    "org/cinnamon/desktop/keybindings" = {
      looking-glass-keybinding = ["<Control><Alt>l"];
    };

    "org/cinnamon/desktop/keybindings/media-keys" = {
      screensaver = ["<Super>l"];
      terminal = ["<Super>t"];
    };

    # Desktop
    "org/cinnamon/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/Pictures/Wallpapers/rainy_city.jpg";
      picture-options = "zoom";
    };
    "org/cinnamon/desktop/background/slideshow" = {
      slideshow-enabled = false;
    };
    "org/cinnamon/desktop/screensaver" = {
      lock-enabled = true;
      idle-activation-enabled = true;
      picture-uri = "file://${config.home.homeDirectory}/Pictures/Wallpapers/rainy_city.jpg";
      picture-options = "zoom";
    };
    "org/nemo/preferences" = {
      show-home-icon-toolbar = true;
      show-new-folder-icon-toolbar = true;
      show-open-in-terminal-toolbar = true;
      default-folder-viewer = "list-view";
      show-hidden-files = true;
      executable-text-activation = "display";
    };
    "org/nemo/desktop" = {
      font = "CaskaydiaCove Nerd Font 10";
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "PNW_cinnamon_theme";
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Nordzy-cursors";
      cursor-size = cursorSize;
      font-name = "CaskaydiaCove Nerd Font 10";
      document-font-name = "CaskaydiaCove Nerd Font 10";
      monospace-font-name = "CaskaydiaCove Nerd Font Mono 10";
    };
  };

  # Home
  home.pointerCursor = {
    name = "Nordzy-cursors";
    package = pkgs.nordzy-cursor-theme;
    size = cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };

  # Default xdg
    xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Text & Code
      "text/plain" = ["org.kde.kate.desktop"];
      "text/markdown" = ["org.kde.kate.desktop"];
      "text/x-readme" = ["org.kde.kate.desktop"];
      "text/x-log" = ["org.kde.kate.desktop"];
      "text/csv" = ["org.kde.kate.desktop"];
      "text/html" = ["librewolf.desktop"];
      "text/xml" = ["org.kde.kate.desktop"];
      "application/json" = ["org.kde.kate.desktop"];
      "application/xml" = ["org.kde.kate.desktop"];
      "application/x-shellscript" = ["org.kde.kate.desktop"];
      "application/x-yaml" = ["org.kde.kate.desktop"];
      "application/toml" = ["org.kde.kate.desktop"];

      # Web
      "x-scheme-handler/http" = ["librewolf.desktop"];
      "x-scheme-handler/https" = ["librewolf.desktop"];
      "x-scheme-handler/about" = ["librewolf.desktop"];
      "x-scheme-handler/unknown" = ["librewolf.desktop"];

      # Images
      "image/png" = ["org.nomacs.ImageLounge.desktop"];
      "image/jpeg" = ["org.nomacs.ImageLounge.desktop"];
      "image/gif" = ["org.nomacs.ImageLounge.desktop"];
      "image/webp" = ["org.nomacs.ImageLounge.desktop"];
      "image/svg+xml" = ["org.inkscape.Inkscape.desktop"];
      "image/bmp" = ["org.nomacs.ImageLounge.desktop"];
      "image/tiff" = ["org.nomacs.ImageLounge.desktop"];

      # Video
      "video/mp4" = ["vlc.desktop"];
      "video/x-matroska" = ["vlc.desktop"];
      "video/webm" = ["vlc.desktop"];
      "video/avi" = ["vlc.desktop"];
      "video/quicktime" = ["vlc.desktop"];
      "video/x-msvideo" = ["vlc.desktop"];

      # Audio
      "audio/mpeg" = ["vlc.desktop"];
      "audio/mp3" = ["vlc.desktop"];
      "audio/flac" = ["vlc.desktop"];
      "audio/ogg" = ["vlc.desktop"];
      "audio/wav" = ["vlc.desktop"];
      "audio/x-wav" = ["vlc.desktop"];

      # Documents
      "application/pdf" = ["org.kde.okular.desktop"];  # or your PDF viewer
      "application/epub+zip" = ["calibre-ebook-viewer.desktop"];
      "application/x-mobipocket-ebook" = ["calibre-ebook-viewer.desktop"];

      # Archives
      "application/zip" = ["engrampa.desktop"];
      "application/x-tar" = ["engrampa.desktop"];
      "application/gzip" = ["engrampa.desktop"];
      "application/x-7z-compressed" = ["engrampa.desktop"];
      "application/x-rar" = ["engrampa.desktop"];

      # File manager
      "inode/directory" = ["nemo.desktop"];

      # Office (if using OnlyOffice)
      "application/vnd.oasis.opendocument.text" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.oasis.opendocument.spreadsheet" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.oasis.opendocument.presentation" = ["onlyoffice-desktopeditors.desktop"];
      "application/msword" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.ms-excel" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.ms-powerpoint" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];
    };
  };

  # gtk bookmarks
  gtk.gtk3.bookmarks = [
    "file://${config.home.homeDirectory}/Documents"
    "file://${config.home.homeDirectory}/Downloads"
    "file://${config.home.homeDirectory}/Pictures"
    "file://${config.home.homeDirectory}/Videos"
    "file://${config.home.homeDirectory}/Music"
    "file:///etc/nixos NixOS Config"
  ];

  # Desktop Shortcuts
  home.file = {
    "Desktop/LibreWolf.desktop" = {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=LibreWolf
        Exec=librewolf
        Icon=librewolf
        Terminal=false
        Categories=Network;WebBrowser;
      '';
    };
    "Desktop/MullvadBrowser.desktop" = {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Mullvad Browser
        Exec=mullvad-browser
        Icon=mullvad-browser
        Terminal=false
        Categories=Network;WebBrowser;
      '';
    };
    "Desktop/Brave.desktop" = {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Brave
        Exec=brave
        Icon=brave
        Terminal=false
        Categories=Network;WebBrowser;
      '';
    };
    "Desktop/NixOS.desktop" = {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=NixOS Config
        Exec=nemo /etc/nixos
        Icon=nix-snowflake-white
        Terminal=false
        Categories=System;
      '';
    };
    "Desktop/VSCode.desktop" = {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=VS Code
        Exec=code
        Icon=vscode
        Terminal=false
        Categories=Development;IDE;
      '';
    };
    "Desktop/HomeServer.desktop" = {
      executable = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Home Server
        Exec=nemo sftp://parka_admin@172.30.152.50
        Icon=server-database-symbolic
        Terminal=false
        Categories=Network;
      '';
    };
    "Desktop/Steam.desktop" = {
      executable=true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Steam
        Exec=steam %U
        Icon=steam
        Terminal=false
        Categories=Games;
      '';
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "parka5040";
        email = "parka735@protonmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "code --wait";
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "code --wait";
    };
  };

  # zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -la";
      nix-rebuild = "sudo nixos-rebuild switch";
      nix-reboot = "sudo nixos-rebuild boot";
      nix-cleanup = "sudo nix-collect-garbage --delete-older-than 7d";
      nix-code = "code /etc/nixos";
      nix-purge = "sudo nix-collect-garbage --delete-old";
      nix-listenv = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nix-edit = "kate /etc/nixos/";
      nvidia-run = "nvidia-offload";
      nix-file = "nemo /etc/nixos &";
      nix-gc = "sudo nix-store --gc";
      nix-cd = "cd /etc/nixos";
      screen-nudge = "xrandr --output HDMI-0 --off && xrandr --output HDMI-0 --auto";
    };
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Enable Powerlevel10k instant prompt (must be at top)
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        # Nix commit git helper
        nix-commit() {
          (cd /etc/nixos && git add . && git commit "$@" && git push)
        }

        # Delete a range of NixOS generations (inclusive)
        nix-delete-generations() {
          if [[ $# -ne 2 ]]; then
            echo "Usage: nix-delete-generations <start> <end>"
            return 1
          fi
          sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations $(seq $1 $2)
        }

        # Load Powerlevel10k config
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''
    ];
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "history"
        "kubectl"
      ];
    };
  };

  # Kitty terminal - using external config
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./config/kitty/kitty.conf;
  };

  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override { commandLineArgs = "--disable-telemetry"; };
    mutableExtensionsDir = false; # Just make life easy, manage from here

    profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./config/vscode/settings.json);

    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Languages (from nixpkgs)
      ms-python.python
      ms-python.vscode-pylance
      golang.go
      ms-vscode.cpptools

      # Utilities
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      christian-kohler.path-intellisense

      # Remote
      ms-vscode-remote.remote-ssh

      # Markdown
      yzhang.markdown-all-in-one

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Nix IDE
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.3.5";
        sha256 = "sha256-hiyFZVsZkxpc2Kh0zi3NGwA/FUbetAS9khWxYesxT4s=";
      }
      # Kotlin
      {
        name = "Kotlin";
        publisher = "mathiasfrohlich";
        version = "1.7.1";
        sha256 = "sha256-MuAlX6cdYMLYRX2sLnaxWzdNPcZ4G0Fdf04fmnzQKH4=";
      }
      # C#
      {
        name = "csharp";
        publisher = "ms-dotnettools";
        version = "2.18.16";
        sha256 = "sha256-A/HcFp4fUuqvnggQOWvPoHnIXe0oVTPdbYDCA4bp088=";
      }
      # Auto Rename Tag
      {
        name = "auto-rename-tag";
        publisher = "formulahendry";
        version = "0.1.10";
        sha256 = "sha256-uXqWebxnDwaUVLFG6MUh4bZ7jw5d2rTHRm5NoR2n0Vs=";
      }
      # Remote Containers
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.392.0";
        sha256 = "sha256-VkOf+6QNsKcd0hiX8ojAro/OyYRyCVrROD+ph0cAge4=";
      }
      # Gruvbox Material Icons
      {
        name = "gruvbox-material-icon-theme";
        publisher = "JonathanHarty";
        version = "1.1.5";
        sha256 = "sha256-86UWUuWKT6adx4hw4OJw3cSZxWZKLH4uLTO+Ssg75gY=";
      }
      # Cline
      {
        name = "claude-dev";
        publisher = "saoudrizwan";
        version = "3.40.1";
        sha256 = "sha256-QlNx+8cBjdxINl25qW0LAevpEJU8yjuXaQbpocuoMgI=";
      }
    ];
  };

  # XDG directories and config files
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
    configFile = {
      # Kvantum theming - link to system theme
      "Kvantum/PNW-Cinnamon".source = "${pnw-cinnamon-theme}/share/themes/PNW_cinnamon_theme/Kvantum/PNW-Cinnamon";
      "Kvantum/kvantum.kvconfig".source = ./config/kvantum.kvconfig;

      # KDE globals for KDE6 apps (Kate, etc.)
      "kdeglobals".source = ./config/kde/kdeglobals;

      # Kate
      "katerc".source = ./config/katerc;
    };
    dataFile = {
      # KDE color scheme
      "color-schemes/PNW-Cinnamon.colors".source = ./config/kde/PNW-Cinnamon.colors;

      # Kate syntax theme
      "org.kde.syntax-highlighting/themes/PNW-Rain.theme".source = ./config/kde/PNW-Rain.theme;
    };
  };

  # Activation script to install userChrome.css to Firefox-based browsers
  home.activation.installBrowserThemes = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    # LibreWolf
    if [ -d "${config.home.homeDirectory}/.librewolf" ]; then
      LIBREWOLF_PROFILE=$(find "${config.home.homeDirectory}/.librewolf" -maxdepth 1 -type d -name "*.default*" 2>/dev/null | head -n1)
      if [ -n "$LIBREWOLF_PROFILE" ]; then
        run mkdir -p "$LIBREWOLF_PROFILE/chrome"
        run cp -f ${./config/librewolf/userChrome.css} "$LIBREWOLF_PROFILE/chrome/userChrome.css"
      fi
    fi

    # Mullvad Browser
    if [ -d "${config.home.homeDirectory}/.mullvad/mullvadbrowser" ]; then
      MULLVAD_PROFILE=$(find "${config.home.homeDirectory}/.mullvad/mullvadbrowser" -maxdepth 1 -type d -name "*.default*" 2>/dev/null | head -n1)
      if [ -n "$MULLVAD_PROFILE" ]; then
        run mkdir -p "$MULLVAD_PROFILE/chrome"
        run cp -f ${./config/librewolf/userChrome.css} "$MULLVAD_PROFILE/chrome/userChrome.css"
      fi
    fi
  '';

  # User packages
  home.packages = with pkgs; [
    bat
    eza
    ripgrep
    fd
    fzf
    jq
    btop

    # Theming tools
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];
}
