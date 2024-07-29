{ pkgs, ... }:

{
  services.picom = {
    enable = true;
#    blur = true;
#    blurExclude = [ "window_type = 'dock'" "window_type = 'desktop'" ];


    fade = true;
    fadeDelta = 5;

    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.7;
    shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
#    noDockShadow = true;
#    noDNDShadow = true;

    activeOpacity = 1;
    inactiveOpacity = 1;
    menuOpacity = 1;

    backend = "glx";
    vSync = true;

    # settings = ''
    #  shadow-radius = 7;
    #  clear-shadow = true;
    #  frame-opacity = 0.7;
    #  blur-method = "dual_kawase";
    #  blur-strength = 5;
    #  alpha-step = 0.06;
    #  detect-client-opacity = true;
    #  detect-rounded-corners = true;
    #  paint-on-overlay = true;
    #  detect-transient = true;
    #  mark-wmwin-focused = true;
    # mark-ovredir-focused = true;
    # '';
  };
}
