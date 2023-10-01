# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.zfs.enableUnstable = true; # required for 21.05
  fileSystems."/" =
    { device = "zroot/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/20BF-2755";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "zroot/root/home";
      fsType = "zfs";
    };

    swapDevices = [ ];
    services.zfs.autoScrub.enable = true;
}