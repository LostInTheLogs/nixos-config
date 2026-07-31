{
  den.aspects.profiles.workstation.nixos = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        noto-fonts-cjk-sans
        noto-fonts
        noto-fonts-lgc-plus
        noto-fonts-color-emoji
        nerd-fonts.fira-code
        my.iosevka-custom
        corefonts
        my.twitter-color-emoji
        # twitter-color-emoji
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = ["Noto Sans"];
          monospace = ["Iosevka Custom"];
          emoji = ["Twitter Color Emoji"];
        };
        confPackages = [
          (pkgs.writeTextFile {
            name = "fc-twemoji-color-config";
            destination = "/etc/fonts/conf.d/46-twemoji-color.conf";
            text = ''
              <?xml version="1.0" encoding="UTF-8"?>
              <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
              <fontconfig>
                <alias binding="strong">
                  <family>Apple Color Emoji</family>
                  <prefer><family>Twitter Color Emoji</family></prefer>
                  <default><family>sans-serif</family></default>
                </alias>
                <alias binding="strong">
                  <family>Segoe UI Emoji</family>
                  <prefer><family>Twitter Color Emoji</family></prefer>
                  <default><family>sans-serif</family></default>
                </alias>
                <alias binding="strong">
                  <family>Noto Color Emoji</family>
                  <prefer><family>Twitter Color Emoji</family></prefer>
                  <default><family>sans-serif</family></default>
                </alias>
              </fontconfig>
            '';
          })
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      kdePackages.plasma-pa
      kdePackages.filelight
      kdePackages.partitionmanager
      kdePackages.ark # for dolphin
      (kdePackages.spectacle.override {tesseractLanguages = ["all"];})
      proton-vpn
      bottles

      calibre
    ];

    networking.firewall.allowedTCPPorts = [
      9090 #calibre
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    programs.firefox.enable = true;

    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 3;
    };
    systemd.services.earlyoom.serviceConfig.User = "vodfsh"; # TODO: remove https://github.com/NixOS/nixpkgs/pull/375649

    systemd.settings.Manager = {
      DefaultTimeoutStartSec = "10s";
      DefaultTimeoutStopSec = "10s";
      DefaultTimeoutAbortSec = "10s";
      DefaultDeviceTimeoutSec = "10s";
    };

    services.flatpak.enable = true;
    xdg.portal.enable = true;

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.defaultSession = "plasma";

    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      gutenprint
      gutenprint-bin
      brgenml1lpr
      brgenml1cupswrapper
      pkgs.cnijfilter2
      hplip
      hplipWithPlugin # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
      splix
      brlaser
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    hardware.enableAllFirmware = true;
  };

  den.aspects.profiles.workstation.homeManager = {
    pkgs,
    osConfig,
    ...
  }: let
    ai-krita = pkgs.writeShellApplication {
      name = "ai-krita";
      runtimeInputs = with pkgs; [
        krita
        steam-run
      ];
      text = ''
        SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt steam-run krita
      '';
    };
  in {
    programs.mpv = {
      enable = true;

      package = (
        pkgs.mpv.override {
          scripts = with pkgs.mpvScripts; [
            # autosub # needs python subliminal cli
            autosubsync-mpv
            webtorrent-mpv-hook
            sponsorblock-minimal
            modernz
            mpris
            pkgs.mpvScripts.builtins.autocrop
            pkgs.mpvScripts.builtins.autoload
            pkgs.mpvScripts.eisa01.simplehistory
            pkgs.mpvScripts.eisa01.smartskip
            pkgs.mpvScripts.eisa01.undoredo
            pkgs.mpvScripts.eisa01.smart-copy-paste-2
          ];
        }
      );

      scriptOpts = {
        webtorrent = {
          path = "~/Videos/mpv/";
        };

        osc = {
          chapters_osd = false;
          playlist_osd = false;
        };

        autocrop = {
          auto = false;
        };

        SmartSkip = {
          autoskip_chapter = false;
        };
      };

      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        sub-pos = 102;
        sub-scale = 0.6;
        osd-bar = false;
        alang = "en,eng,enUS,en-US";
        slang = "en,eng,enUS,en-US";
        sub-auto = "fuzzy";
        subs-with-matching-audio = "forced";
      };
    };

    home.packages = with pkgs; [
      ungoogled-chromium

      # youtube-music

      vesktop
      (pkgs.discord.override {withVencord = true;})
      obsidian
      # josm
      unstable.deskflow

      # weylus
      krita
      ai-krita
      gimp-with-plugins
      inkscape

      audacity
      kdePackages.kdenlive
      losslesscut-bin
      ffmpeg-full
      yt-dlp
      # subtitleedit
      # unstable.aegisub

      obs-studio

      libreoffice
      pdfarranger
      vlc

      lrcget
      picard
    ];

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };

    fonts.fontconfig.enable = true;
  };
}
