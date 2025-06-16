{ pkgs, ... }:

{
  programs.direnv.enable = true;
  services.flatpak.enable = true;
  programs.dconf.enable = true;
}
