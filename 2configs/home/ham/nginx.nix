let
  internal-ip = "192.168.111.11";
in {
  services.nginx.recommendedProxySettings = true;
  services.nginx.virtualHosts."hass" = {
    serverAliases = [ "hass.lan" "ha" "ha.lan" ];
    locations."/".proxyPass = "http://localhost:8123";
    locations."/".proxyWebsockets = true;
    extraConfig = ''
      if ( $server_addr != "${internal-ip}" ) {
        return 403;
      }
    '';
  };
}
