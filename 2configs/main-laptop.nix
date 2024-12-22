{ config, lib, pkgs, stockholm, ... }:

# stuff for the main laptop
# this is pretty much nice-to-have and does
# not fit into base-gui
# TODO split generic desktop stuff and laptop-specifics like lidswitching

let
  window-manager = "awesome";
  user = config.krebs.build.user.name;
in {
  imports = [
    ./gui/base.nix
    # ./gui/look-up.nix
    ./fetchWallpaper.nix
    ./zsh
    ./tools/core.nix
    ./tools/core-gui.nix
    ./gui/automatic-diskmount.nix
  ];

  users.users.${config.krebs.build.user.name}.extraGroups = [ "dialout" ];

  location.latitude = 48.7;
  location.longitude = 9.1;

}
