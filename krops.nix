{ config ? config, name, target ? name }: let
  krops = ../submodules/krops;
  nixpkgs-src = lib.importJSON ./nixpkgs.json;

  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" {};

  host-src = {
    secure = false;
    full = false;
    torrent = false;
    hw = false;
    musnix = false;
    python = false;
    unstable = false; #unstable channel checked out
    mic92 = false;
    nms = false;
    arm6 = false;
    clever_kexec = false;
    home-manager = false;
  } // import (./. + "/1systems/${name}/source.nix");
  source = { test }: lib.evalSource [
    {
      # nixos-18.09 @ 2018-09-18
      # + uhub/sqlite: 5dd7610401747
      nixpkgs = if test || host-src.full then {
        git.ref = nixpkgs-src.rev;
        git.url = nixpkgs-src.url;
      } else if host-src.arm6 then {
        # TODO: we want to track the unstable channel
        symlink = "/nix/var/nix/profiles/per-user/root/channels/nixos/";
      } else {
        file = "/home/makefu/store/${nixpkgs-src.rev}";
      };
      nixos-config.symlink = "stockholm/makefu/1systems/${name}/config.nix";

      stockholm.file = toString ./..;
      secrets = if test then {
        file = toString ./0tests/data/secrets;
      } else {
        pass = {
          dir = "${lib.getEnv "HOME"}/.secrets-pass";
          inherit name;
        };
      };
    }
    (lib.mkIf (host-src.torrent) {
      torrent-secrets = if test then {
        file =  toString ./0tests/data/secrets;
      } else {
        pass = {
          dir = "${lib.getEnv "HOME"}/.secrets-pass";
          name = "torrent";
        };
      };
    })
    (lib.mkIf ( host-src.musnix ) {
      musnix.git = {
        url = https://github.com/musnix/musnix.git;
        ref = "master"; # follow the musnix channel, lets see how this works out
      };
    })
    (lib.mkIf ( host-src.hw ) {
      nixos-hardware.git = {
        url = https://github.com/nixos/nixos-hardware.git;
        ref = "30fdd53";
      };
    })
    (lib.mkIf ( host-src.home-manager ) {
      home-manager.git = {
        url = https://github.com/rycee/home-manager;
        ref = "6eea2a4";
      };
    })
  ];

in {
  # usage: $(nix-build --no-out-link --argstr name HOSTNAME -A deploy)
  deploy = pkgs.krops.writeDeploy "${name}-deploy" {
    source = source { test = false; };
    target = "root@${target}/var/src";
  };

  # usage: $(nix-build --no-out-link --argstr name HOSTNAME --argstr target PATH -A test)
  test = { target ? target }: pkgs.krops.writeTest "${name}-test" {
    inherit target;
    source = source { test = true; };
  };
}