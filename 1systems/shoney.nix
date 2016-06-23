{ config, pkgs, ... }:
let
  tinc-siem-ip = "10.8.10.1";

  ip     = "64.137.234.215";
  alt-ip = "64.137.234.210";
  extra-ip = "64.137.234.114"; #currently unused
  gw = "64.137.234.1";
in {
  imports = [
    ../.
    ../2configs/save-diskspace.nix
    ../2configs/hw/CAC.nix
    ../2configs/fs/CAC-CentOS-7-64bit.nix
  ];



  services.tinc.networks.siem.name = "sjump";

  krebs = {
    enable = true;
    retiolum.enable = true;
    build.host = config.krebs.hosts.shoney;
    nginx.enable = true;
    tinc_graphs = {
      enable = true;
      network = "siem";
      hostsPath = "/etc/tinc/siem/hosts";
      nginx = {
        enable = true;
        # TODO: remove hard-coded hostname
        complete = {
          listen = [ "${tinc-siem-ip}:80" ];
          server-names = [ "graphs.siem" ];
        };
      };
    };
  };
  networking =  {
    interfaces.enp2s1.ip4 = [
      { address = ip; prefixLength = 24; }
      { address = alt-ip; prefixLength = 24; }
    ];

    defaultGateway = gw;
    nameservers = [ "8.8.8.8" ];
    firewall = {
      trustedInterfaces = [ "tinc.siem" ];
      allowedUDPPorts = [ 655 1655 ];
      allowedTCPPorts = [ 655 1655 ];
    };
  };
}