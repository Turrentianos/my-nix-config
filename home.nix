{ pkgs, inputs, ... }:
{
  home.username = "llionakis";
  home.homeDirectory = "/home/llionakis";

  imports = [];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Essentials
    firefox
    pavucontrol
    blueman
    arandr
    xfce.thunar
    rofi-wayland
    xsel
    keymapp
    k3d
    thunderbird

    # Nice to have
    ghostty
    wezterm
    oh-my-zsh
    networkmanagerapplet
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
    # install a few random packages for me

    # Work
    flameshot
    peek
    rocketchat-desktop
    keepassxc
    google-chrome
    vscodium
    openconnect
    awscli2
    git-lfs
    vmware-horizon-client
    vale
    (python312.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      pip
      boto3
    ]))
    ruff
    gh
    sshuttle

    # Infra
    ## Kubernetes
    kubectl
    kubectx
    k9s
    minikube

    kustomize
    kustomize-sops
    
    terraform
    terraform-docs
    terragrunt

    sops
    pre-commit
    devbox

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
    devenv
    quickemu

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
