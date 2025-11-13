{ config, lib, pkgs, ... }:
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

    flaresolverr.enable = true;

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
}
