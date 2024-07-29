{
   programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    config = {
      placeholder = "Example";
      fullscreen = true;
      list = {
        height = 200;
      };
      modules = [
        {
          name = "websearch";
          prefix = "?";
        }
        {
          name = "switcher";
          prefix = "/";
        }
      ];
    };

    # If this is not set the default styling is used.
    style = ''
      * {
        color: #dcd7ba;
      }
    '';
  };
}