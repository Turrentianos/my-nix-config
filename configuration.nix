# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ pkgs, inputs, ... }:

{
  home-manager.backupFileExtension = "configFilesBackup";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.extraOptions = ''
      experimental-features = nix-command flakes repl-flake
  '';
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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

  boot.supportedFilesystems = [ "ntfs" ];

  virtualisation.docker.enable = true;

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

    displayManager = {
      defaultSession = "none+i3";
      sddm.autoNumlock = true;
    };

    xserver = {
      enable = true;
      xkb.layout = "us";

      windowManager.i3 = {
        enable = true;
	      package = pkgs.i3-gaps;
      };
      displayManager.sddm.enable = true;
      # desktopManager.gnome.enable = true;
    };

    # knot.enable = true;
  };
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.pulseaudio.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" "crane_public" "scientists" "mathematicians" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];
  
  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  networking.hosts = {
    "127.0.0.1" = [ "turrentianos" "localhost" "www.youtube.com" "m.youtube.com" "youtu.be" "youtube.com"];
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
