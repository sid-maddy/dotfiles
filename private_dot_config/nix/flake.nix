{
  description = "System";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*.tar.gz";

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    determinate,
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
        fish
        nushell
        powershell

        ## Completer
        carapace

        ## Editors
        helix

        # Tools
        bat
        graphviz
        less
        libqalculate
        watchexec

        ## Git
        difftastic
        gitoxide
        gitui
        lazygit

        ## Text processing
        miller
        yq-go

        ## Encryption
        age
        sops

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
        ipcalc # Build fails because of transitive dependency: nokogiri
        ldns # For drill

        ## Containers/images
        crane
        dive
        trivy

        ## Kubernetes
        k9s
        kubeshark
      ];

      # Necessary for using flakes on this system.
      nix.settings = {
        experimental-features = "nix-command flakes";
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;
      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "${system}";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#default
    darwinConfigurations.default = nix-darwin.lib.darwinSystem {
      modules = [determinate.darwinModules.default configuration];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.default.pkgs;

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
