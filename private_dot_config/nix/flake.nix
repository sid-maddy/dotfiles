{
  description = "System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
  }: let
    system = "aarch64-darwin";

    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        # Nix Formatter
        alejandra

        # Shells
        nushellFull
        powershell

        ## Completer
        carapace

        # Editors
        helix

        # Tools
        bat
        less
        libqalculate
        watchexec

        ## Git
        difftastic
        # gitoxide  # build fails
        gitui

        ## Text processing
        miller
        yq-go

        ## Encryption
        age

        ## Process monitoring
        bottom
        htop
        procs

        ## Build/task systems
        earthly
        just

        ## Log processing
        lnav

        ## Networking
        prettyping
        ipcalc
        ldns # for drill
        sipcalc

        ## Containers/images
        crane
        dive

        ## Kubernetes
        k9s
        kubeshark

        ## Helm  # Need to be debugged
        # kubernetes-helm-wrapped
        # kubernetes-helmPlugins.helm-diff
        # kubernetes-helmPlugins.helm-secrets  # build fails
        # helmfile-wrapped
      ];

      # Auto upgrade nix package and the daemon service.
      nix.package = pkgs.nix;
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      # Partly taken from https://github.com/DeterminateSystems/nix-installer/
      nix.settings = {
        auto-optimise-store = true;
        bash-prompt-prefix = "(nix:$name)\\040";
        experimental-features = "nix-command flakes auto-allocate-uids";
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        trusted-users = ["root" "siddheshmhadnak"];
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "${system}";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#default
    darwinConfigurations.default = nix-darwin.lib.darwinSystem {
      modules = [configuration];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.default.pkgs;

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
