{ pkgs, ... }:

{
  # GNOME setup
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
  
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany # web browser
    geary # email reader
    evince # document viewer
  ];
}
