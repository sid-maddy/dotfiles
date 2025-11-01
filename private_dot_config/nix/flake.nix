{
  # A helpful description of your flake
  description = "System";

  # Flake inputs
  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake outputs that other flakes can use
  outputs = { self, flake-schemas, nixpkgs, nix-darwin }:
    let
      system = "aarch64-darwin";

      configuration = { pkgs, ... }: {
        # Ensure that `nix-darwin``’s own Nix installation management is disabled.
        nix.enable = false;

        # Necessary for using flakes on this system.
        nix.settings = {
          experimental-features = "nix-command flakes";
        };

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "${system}";

        # Allow unfree packages.
        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          # Nix Formatter
          alejandra

          # Shell
          fish

          ## Completer
          carapace

          # Tools
          bat
          graphviz
          less
          libqalculate
          poppler
          poppler_data
          watchexec

          ## Git
          difftastic
          gitoxide

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
          ipcalc

          ## Containers/images
          crane
          dive
          trivy

          ## Kubernetes
          k9s
          kubeshark

          ## Archivers
          _7zz

          ## Media players
          mpv
        ];

        # Enable alternative shell support in nix-darwin.
        programs.fish.enable = true;
        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;
      };
    in {
      # Schemas tell Nix about the structure of your flake's outputs
      schemas = flake-schemas.schemas;

      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#default
      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.default.pkgs;
    };
}
