{ pkgs, lib, ... }:

{
  users.users.makefu.packages = with pkgs;[ bat direnv clipit ];
  home-manager.users.makefu = {
    systemd.user.services.network-manager-applet.Service.Environment = ''XDG_DATA_DIRS=/run/current-system/sw/share:${pkgs.networkmanagerapplet}/share GDK_PIXBUF_MODULE_FILE=${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache'';
    programs.browserpass = { browsers = [ "firefox" ] ; enable = true; };
    programs.firefox.enable = true;
    programs.obs-studio.enable = true;
    xdg.enable = true;
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;
    services.pasystray.enable = true;
    systemd.user.services.pasystray.Service.Environment = "PATH=" + (lib.makeBinPath (with pkgs;[ pavucontrol paprefs /* pavumeter  */  /* paman */ ]) );
    programs.chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        # "liloimnbhkghhdhlamdjipkmadhpcjmn" # krebsgold
        "fpnmgdkabkmnadcjpehmlllkndpkmiak" # wayback machine
        "gcknhkkoolaabfmlnjonogaaifnjlfnp" # foxyproxy
        "abkfbakhjpmblaafnpgjppbmioombali" # memex
        "kjacjjdnoddnpbbcjilcajfhhbdhkpgk" # forest
      ];
    };

    systemd.user.services.clipit = {
      Unit = {
        Description = "clipboard manager";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        Environment = ''XDG_DATA_DIRS=/run/current-system/sw/share:${pkgs.clipit}/share GDK_PIXBUF_MODULE_FILE=${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache'';
        ExecStart = "${pkgs.clipit}/bin/clipit";
        Restart = "on-abort";
      };
    };
  };
}
