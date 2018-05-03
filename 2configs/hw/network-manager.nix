{ pkgs, lib, ... }:
{
  users.users.makefu = {
    extraGroups = [ "networkmanager" ];
    packages = with pkgs;[
      networkmanagerapplet
      gnome3.gnome_keyring gnome3.dconf
    ];
  };
  networking.wireless.enable = lib.mkForce false;

  systemd.services.modemmanager = {
    description = "ModemManager";
    bindsTo = [ "network-manager.service" ];
    wantedBy = [ "network-manager.service" "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.modemmanager}/bin/ModemManager";
      PrivateTmp = true;
      Restart = "always";
      RestartSec = "5";
    };
  };
  networking.networkmanager.enable = true;

  # TODO: put somewhere else
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.clipit}/bin/clipit &
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    '';

# nixOSUnstable
# networking.networkmanager.wifi = {
#   powersave = true;
#   scanRandMacAddress = true;
# };
}