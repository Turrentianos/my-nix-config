{ pkgs, inputs, ... }:
  # let 
  #   vmware-horizon-client-22-05 = pkgs22-05.vmware-horizon-client; 
  # in
{
  # TODO please change the username & home direcotry to your own
  home.username = "llionakis";
  home.homeDirectory = "/home/llionakis";

  imports = [
    ./compton.nix
    ./i3.nix
    ./polybar.nix
    ./redshift.nix
    ./rofi.nix
    ./hyprland.nix
    ./walker.nix
    inputs.walker.homeManagerModules.walker
    inputs.hyprland.homeManagerModules.default
    # ./alacritty.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Essentials
    firefox
    pavucontrol
    blueman
    arandr
    xfce.thunar

    # Nice to have
    wezterm
    oh-my-zsh
    networkmanagerapplet
    zellij
    killall
    dig
    lshw
    htop
    vlc
    spotify
    telegram-desktop
    zoxide
    fzf
    autorandr
    eza
    delta
    lazygit
    bmon
    iftop
    tcpflow
    brightnessctl

    # Work
    flameshot
    rocketchat-desktop
    keepassxc
    google-chrome
    vscodium
    openconnect
    awscli2
    git-lfs
    vmware-horizon-client

    ## Kubernetes
    kubectl
    kubectx
    k9s
    minikube
    kustomize

    # Terminal stuff
    feh
    nixfmt-classic
    nix-direnv
    ripgrep
    nurl
    jq

    any-nix-shell
    unrar
    unzip
    tree

    # lsp
    nil
    nixpkgs-fmt

    # Network
    knot-resolver
  ];

  home.sessionVariables = { EDITOR = "nvim"; };

  xsession.enable = true;

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    starship = {
      enable = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        # package.disabled = true;
      };
    };

    git = {
      enable = true;
      userName = "llionakis";
      userEmail = "lucianos.lionakis@openanalytics.eu";
      package = pkgs.gitFull;
      extraConfig = { credential.helper = "store"; };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    neovim = { enable = true; };

    # nixvim = {
    #  enable = true;
    #  default = true;
    #};
    #bash.enable = true;
    #bash.bashrcExtra = builtins.readFile ./bash_sensible_config.sh;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "agnoster";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = { copy_clipboard = "primary"; };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  # programs.home-manager.enable = true;
}
