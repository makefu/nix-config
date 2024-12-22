{ config, lib, pkgs, modulesPath, ... }:
{

  imports =
    [ ./network.nix
      (modulesPath + "/profiles/qemu-guest.nix")
    ];
  
  # Disk
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.uki.tries = 3;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/nix";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };

  swapDevices = [ ];
  # zramSwap.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostId = "3150697b"; # required for zfs use
  # boot.tmp.useTmpfs = true;
  boot.supportedFilesystems = [ "zfs" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.zfs.devNodes = "/dev"; # fixes some virtualmachine issues
  boot.kernelParams = [
    #"zfs.zfs_arc_max=1073741824" # 1gb
    "zfs.zfs_arc_max=134217728" # 128mb
    "boot.shell_on_fail"
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
}
