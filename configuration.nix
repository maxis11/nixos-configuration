# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 10;
    };
    kernel.sysctl."net.ipv4.forwarding" = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-amd" "fuse" "coretemp"];
    cleanTmpDir = true;
    plymouth.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      tcp = {
        enable = true;
        anonymousClients = {
          allowedIpRanges = [ "127.0.0.1" ];
        };
      };
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      s3tcSupport = true;
    };
    trackpoint = {
      enable = true;
      sensitivity = 200;
      emulateWheel = true;
    };
    enableAllFirmware = true;
  };

  sound.enable = true;

  system = {
    stateVersion = "18.03";
    autoUpgrade.enable = true;
  };

  networking = {
    hostName = "zatm8";
    networkmanager.enable = true;
    # wireless.enable = true;
    firewall.enable = false; #TODO: enable
    enableB43Firmware = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    virtualbox = {
      enableExtensionPack = true;
      pulseSupport = true;
    };
  };

  nix = {
    trustedBinaryCaches = [
      "https://cache.nixos.org/"
    ];
    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    useSandbox = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Moscow";

  environment = {
    interactiveShellInit = ''
    '';
    shells = [
      "${pkgs.bash}/bin/bash"
      "${pkgs.fish}/bin/fish"
    ];
    variables = {
      BROWSER = pkgs.lib.mkOverride 0 "firefox";
      EDITOR = pkgs.lib.mkOverride 0 "nvim";
      MESSENGER = "telegram-desktop";
      XCURSOR_PATH = [
        "${config.system.path}/share/icons"
        "$HOME/.icons"
        "$HOME/.nix-profile/share/icons/"
      ];
      GTK_DATA_PREFIX = [
        "${config.system.path}"
      ];
      #FIXME: application menu doesn't work if using wayland platform
      # QT_QPA_PLATFORM = "wayland"; 
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # _JAVA_AWT_WM_NONREPARENTING = "1";
      SWAY_CURSOR_THEME="breeze_cursors";
      SWAY_DEBUG="false";
      VDPAU_DRIVER="r600";
    };
    systemPackages = with pkgs; [
      # dev
      vim_configurable
      tmux
      tree
      screen
      screenfetch
      gitAndTools.gitFull
      mosh
      fish
      neovim
      python
      meson
      manpages
      gcc_multi
      clang
      clang-tools
      lldb
      gdb
      tcpdump
      nmap
      openjdk
      docker

      # desktop
      sway
      i3
      i3status
      rxvt_unicode
      dmenu
      i3lock
      light
      termite

      # iphone 
      libimobiledevice
      usbmuxd

      # email
      mutt
      gnupg
      gnupg1compat

      # apps
      mpv
      mpd
      ncmpcpp
      chromium
      firefox
      tor
      i2pd
      file
      wineStaging
      libreoffice
      calibre
      binutils
      wget
      networkmanager_openvpn
      openvpn
      pdftk
      zip
      unrar
      which
      xpdf
      inetutils
      htop
      ghostscript
      libvdpau
      ffmpeg
      elfutils
      xorg.xkill
      iptables
      sudo
      zlib
      bzip2
      bc
      mkpasswd
      gnash
      geoclue2
      gnome3.dconf
      matterbridge
      youtube-dl
      qt5.full
      wayland-protocols
      kdeFrameworks.kwayland
      kwayland-integration
      lxappearance
      qt5ct
      lm_sensors
      acpi
      udiskie

      #themes
      gnome3.gnome-themes-standard
      gnome3.defaultIconTheme
      arc-theme
      arc-icon-theme
      breeze-qt5
      breeze-gtk
      breeze-icons
      hicolor-icon-theme
    ];
  };

  programs = {
    bash = {
      enableCompletion = true;
    };
    fish = {
      enable = true;
    };
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        i3status 
        i3lock 
        light 
        termite
        xwayland 
        rxvt_unicode 
        dmenu
      ];
      extraSessionCommands = ''
        export XKB_DEFAULT_LAYOUT=us,ru
        export XKB_DEFAULT_VARIANT=nodeadkeys
        export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
        export WLC_REPEAT_DELAY=660
        export WLC_REPEAT_RATE=25
      '';
    };
    tmux = {	
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };
    qt5ct.enable = true;
    java.enable = true;
    mtr.enable = true;
    gnupg.agent = { enable = true; enableSSHSupport = true; };
  };

  services = {
    dnscrypt-proxy.enable = true;
    acpid.enable = true;
    timesyncd.enable = true;
    locate.enable = true;
    printing.enable = true;
    geoclue2.enable = true;
    # TODO: enable this
    # flatpak.enable = true; 
    # FIXME: redshift doesn't work with sway 
    # redshift = {
    #   enable = true;
    #   provider = "geoclue2";
    #   temperature.day = 5700;
    #   temperature.night = 4600;
    # };
    openvpn = {
      servers = {
        officeVPN  = { config = '' config /root/nixos/openvpn/officeVPN.conf ''; };
      };
    };
    mpd = {
      enable = true;  
      user = "zatm8";
      group = "users";
      musicDirectory = "/home/zatm8/Music";
      dataDir = "/home/zatm8/.mpd";
      extraConfig = ''
        audio_output {
          type    "pulse"
          name    "Local MPD"
          server  "127.0.0.1"
        }
      '';
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
    tlp = {
      enable = true;
    };
    xserver = {
      enable = true;
      autorun = false;
      exportConfiguration = true;
      layout = "us,ru";
      xkbOptions = "grp:alt_shift_toggle";
      libinput.enable = true;
      videoDrivers = [ "radeon" "virtualbox" "swr" ];
      # displayManager.slim.enable = true;
      # windowManager.i3.enable = true;
      # desktopManager.default = "none";
      # windowManager.default = "i3";
    };
    #BUG: hibernate doesn't working properly on my laptop
    logind.extraConfig = ''
      HandleSuspendKey=suspend
      HandleHibernateKey=suspend
      HandleLidSwitch=ignore
      HandleLidSwitchDocked=ignore
      SuspendKeyIgnoreInhibited=yes
      HibernateKeyIgnoreInhibited=yes
      LidSwitchIgnoreInhibited=yes
    '';
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      terminus_font_ttf
      tewi-font
      kochi-substitute-naga10
      source-code-pro
      source-sans-pro
      source-serif-pro
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      inconsolata 
      ubuntu_font_family
      dejavu_fonts
    ];
  };
  
  systemd.user.services."udiskie" = {
    enable = true;
    description = "udiskie to automount removable media";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      gnome3.defaultIconTheme
      gnome3.gnome_themes_standard
      pythonPackages.udiskie
    ];
    environment.XDG_DATA_DIRS="${pkgs.breeze-icons}/share:${pkgs.gnome3.defaultIconTheme}/share:${pkgs.gnome3.gnome_themes_standard}/share";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie -a -t -n -F ";
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
      configFile = ''
        zatm8 "zatm8" = (root) NOPASSWD: /run/current-system/sw/sbin/openvpn
      '';
    };
    rtkit.enable = true;
    pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; } 
    ];
  };

  users = {
    mutableUsers = false;
    extraUsers.zatm8 = {
      isNormalUser = true;
      description = "zatm8";
      group = "users";
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "vboxusers"
        "dialout"
        "docker"
        "audio"
        "video"
        "systemd-journal"
        "disk"
        "power"
        "sway"
      ];
      home = "/home/zatm8";
      createHome = true;
      shell = pkgs.fish;
    };
  };

  virtualization = {
    libvirtd.enable = true;  
    memorySize = 1024;
    graphics = true;
    qemu = {
      enable = true;
      networkingOptions = [ "-net nic,macaddr=52:53:54:55:56:57" "-net vde,sock=/run/vde.ctl" ];
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      liveRestore = true;
    };
  virtualbox.host.enable = true;
  }; 
}
