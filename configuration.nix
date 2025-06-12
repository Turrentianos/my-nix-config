# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ pkgs, inputs, lib, ... }:

{
  home-manager.backupFileExtension = "configFilesBackup";
  imports =
    [ # Include the results of the hardware scan.
      ./yubikey.nix
      ./bluetooth.nix
      ./services.nix
      ./display-manager.nix
      ./virtualization.nix
      ./hardware-configuration.nix
      # ./finger-print-scanner.nix
    ];

  nix.extraOptions = ''
      experimental-features = nix-command flakes
      trusted-users = root llionakis
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "turrentianos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.networkmanager.settings.main.rc-manager = "unmanaged";
  # networking.networkmanager.dns = "none";
  # networking.resolvconf.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # Configure keymap in X11
  services = {
    dnsmasq = {
      enable = true;
      settings = {
        domain-needed = true;
        no-resolv = true;
        no-poll = true;
        resolv-file = "";
        server =  [
          "/bastion.dev.openanalytics.eu/9.9.9.9"
          "/dev.openanalytics.eu/172.20.0.2"
          "/admin.openanalytics.eu/172.21.0.2"
          "/idm1.openanalytics.eu/172.21.0.2"
          "9.9.9.9"
        ];
      };
    };
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    libinput = {
      mouse = {
        accelProfile = "flat";
        middleEmulation = false;
      };
      enable = true;
    };
  };

  hardware.pulseaudio.enable = false;

  services.udev.extraRules = ''
    # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

    # Legacy rules for live training over webusb (Not needed for firmware v21+)
      # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Moonlander
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      # Rule for the Ergodox EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      # Rule for the Planck EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

    # Wally Flashing rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

    # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
    # Keymapp Flashing rules for the Voyager
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

  # Enable automatic login for the user.
  programs.zsh = {
    enable = true;
  };

  environment.shellAliases = {
    vim = "nvim";
    rebuild = "sudo nixos-rebuild switch --flake ~/.config/my-nixos#turrentianos --show-trace --print-build-logs --verbose";
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.llionakis = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" "crane_public" "scientists" "mathematicians" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    qemu
  ];
  
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # for pre-commit
  programs.nix-ld.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.hosts = {
    "127.0.0.1" = [ "turrentianos" "localhost" "keycloak" "sso1.openanalytics-dev.eu" "www.youtube.com" "m.youtube.com" "youtu.be" "youtube.com"];
    "192.168.49.2" = [ "crane-demo.local" ];
    "10.179.152.49" = [ "vdi.contiwan.com" ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
