# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
      ../2configs/base.nix
      ../2configs/cgit-retiolum.nix
      # ../2configs/graphite-standalone.nix
      ../2configs/vm-single-partition.nix
      ../2configs/tinc-basic-retiolum.nix

      ../2configs/exim-retiolum.nix
      ../2configs/urlwatch.nix
    ];
  krebs.build.host = config.krebs.hosts.pnp;
  krebs.build.user = config.krebs.users.makefu;
  krebs.build.target = "root@pnp";

  krebs.build.deps = {
    nixpkgs = {
      url = https://github.com/NixOS/nixpkgs;
      rev = "13576925552b1d0751498fdda22e91a055a1ff6c";
    };
  };

  networking.firewall.allowedTCPPorts = [
  # nginx runs on 80
  80
  # graphite-web runs on 8080, carbon cache runs on 2003 tcp and udp
  # 8080 2003

  # smtp
  25
  ];

  # networking.firewall.allowedUDPPorts = [ 2003 ];

}
