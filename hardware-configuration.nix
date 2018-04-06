# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-amd" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2b0ed284-b723-405b-9b80-d8db0f5a56fb";
      fsType = "btrfs";
      options = [ "compress=zstd" ]; 
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4235-97A5";
      fsType = "vfat";
    };

  swapDevices = [ {device = "/dev/disk/by-label/swap"; } ]; 
  
  #boot.initrd.postDeviceCommands = "sleep 5";
  #boot.resumeDevice = "/dev/disk/by-label/sleep";
  
  nix.maxJobs = lib.mkDefault 2;
}
