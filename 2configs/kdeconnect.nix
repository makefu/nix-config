{pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ plasma5Packages.kdeconnect-kde ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
}
