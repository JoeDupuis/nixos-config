{ config, lib, pkgs, ... }:
let
  pkgs-unstable = import (
    let revision = "3ec636362e1816bc2f0888fa0fa2c69f1bc9e504"; in
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz";
      sha256 = "177diqkiwphjyqpk2n6nisayx840x28ksvq99kkyi2xsn37fp4md";
    }
  ) { system = pkgs.stdenv.hostPlatform.system; };
in
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../../profiles/kamal.nix
    ../lxc-container
  ];


  environment.systemPackages = with pkgs; [
    rar
    unrar
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = builtins.replaceStrings ["\n"] [""] (builtins.readFile /var/lib/secrets/acme-email);

    certs."dupuis.io" = {
      domain = "*.dupuis.io";
      dnsProvider = "cloudflare";
      group = "nginx";
      credentialsFile = "/var/lib/secrets/acme-dns-credentials";
    };
  };

  services = {
    qbittorrent = {
      enable = true;
      #openFirewall = true;
      torrentingPort = 27429;
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          WebUI = {
            AlternativeUIEnabled = true;
            RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
            Username = "admin";
            Password_PBKDF2 = "@ByteArray(E3vfmBi6HjIm2YYLKTRBmQ==:MBRd4GBnjVEljGauO5erAmBM6lbIraxmXmye7A/eDphXJzy3Cb+z4AMmdI9Bi0cNy7lANzxVE/PUiBjyNkhBng==)";
          };
          General.Locale = "en";
        };

        BitTorrent = {
          # Queueing settings
          "Session\\QueueingSystemEnabled" = true;
          "Session\\MaxActiveDownloads" = 10;
          "Session\\MaxActiveUploads" = 10;
          "Session\\MaxActiveTorrents" = 50;

          # Ignore slow/inactive torrents for queue
          "Session\\IgnoreSlowTorrentsForQueueing" = true;
          "Session\\SlowTorrentsDownloadRate" = 2;      # KiB/s
          "Session\\SlowTorrentsUploadRate" = 2;        # KiB/s
          "Session\\SlowTorrentsInactivityTimer" = 60;  # seconds

          # Seeding limits (any condition triggers removal)
          "Session\\GlobalMaxRatio" = 1.5;
          "Session\\GlobalMaxSeedingMinutes" = 10080;             # 1 week = 7*24*60
          "Session\\GlobalMaxInactiveSeedingMinutes" = 10080;     # 1 week

          # Action: Stop, Remove, RemoveWithContent, EnableSuperSeeding
          "Session\\ShareLimitAction" = "RemoveWithContent";
        };
      };
    };

    plex = {
      enable = true;
      openFirewall = true;
    };


    overseerr = {
      enable = true;
      #openFirewall = true;
    };

    prowlarr = {
      enable = true;
      package = pkgs-unstable.prowlarr;
      #openFirewall = true;
    };

    bazarr = {
      enable = true;
      #openFirewall = true;
    };

    radarr = {
      enable = true;
      #openFirewall = true;
      user = "plex";
      group = "plex";
    };

    sonarr = {
      enable = true;
      #openFirewall = true;
      user = "plex";
      group = "plex";
    };

    flaresolverr = {
      enable = true;
      package = pkgs-unstable.flaresolverr;
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "sonarr.dupuis.io" = {
          forceSSL = true;
          useACMEHost = "dupuis.io";
          locations."/" = {
            proxyPass = "http://127.0.0.1:8989";
            proxyWebsockets = true;
          };
        };
        "radarr.dupuis.io" = {
          forceSSL = true;
          useACMEHost = "dupuis.io";
          locations."/" = {
            proxyPass = "http://127.0.0.1:7878";
            proxyWebsockets = true;
          };
        };
        "overseerr.dupuis.io" = {
          forceSSL = true;
          useACMEHost = "dupuis.io";
          locations."/" = {
            proxyPass = "http://127.0.0.1:5055";
            proxyWebsockets = true;
          };
        };
        "qbittorrent.dupuis.io" = {
          forceSSL = true;
          useACMEHost = "dupuis.io";
          serverAliases = [ "qbit.dupuis.io" ];
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
            extraConfig = ''
          proxy_set_header X-Forwarded-Host $http_host;
        '';
          };
        };
        "plex.dupuis.io" = {
          forceSSL = true;
          useACMEHost = "dupuis.io";
          locations."/" = {
            proxyPass = "http://127.0.0.1:32400";
            proxyWebsockets = true;
          };
        };
        "prowlarr.dupuis.io" = {
          forceSSL = true;
          useACMEHost = "dupuis.io";
          locations."/" = {
            proxyPass = "http://127.0.0.1:9696";
            proxyWebsockets = true;
          };
        };
      };
    };

  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];


  networking.hostName = "plex";


  systemd.network = {
    enable = true;
    networks."50-eth1" = {
      matchConfig.Name = "eth1";
      networkConfig = {
        Address = "192.168.8.50/24";
        Gateway = "192.168.8.1";
        DNS = "192.168.8.1";
        IPv6AcceptRA = true;
      };
      #linkConfig.RequiredForOnline = "routable";
    };
  };

  systemd.services.plex-weekly-restart = {
    description = "Weekly restart of Plex to keep the EAE audio transcoder healthy";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart plex.service";
    };
  };

  systemd.timers.plex-weekly-restart = {
    description = "Weekly Plex restart";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon *-*-* 05:00:00";
      Persistent = true;
    };
  };
}
