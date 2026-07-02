{
  pkgs,
  username ? "ea",
  lib,
  ...
}: let
  pyshell = pkgs.python312.withPackages (ps: [
    ps.ipython
    ps.pandas
    ps.numpy
    ps.numpy-stl
    ps.scipy
    ps.matplotlib
    ps.ptpython
    # ps.pyvista
  ]);

  calc = pkgs.writeShellScriptBin "calc" ''
    ${pyshell}/bin/ipython3
  '';
in {
  stylix.targets = {
    zellij.enable = false;
  };
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      #headless
      calc
      typioca # speed typer/tester
      wl-clipboard
      cliphist
      signal-desktop
      killall
      ripgrep # recursively searches directories for a regex pattern
      fzf # A command-line fuzzy finder
      eza
      gitui
      git-graph
      glow # markdown previewer in terminal
      btop # replacement of htop/nmon
      iftop # network monitoring
      ltrace # library call monitoring
      lsof # list open files
      # archives
      zip
      xz
      unzip
      p7zip
    ];

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };
  # home.activation.generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   KEY_PATH="$HOME/.ssh/eakey"
  #   if [ ! -f "$KEY_PATH" ]; then
  #     echo "Generating missing SSH key..."
  #     ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "$KEY_PATH" -C "your_email@example.com" -N ""
  #     chmod 600 "$KEY_PATH"
  #     chmod 644 "$KEY_PATH.pub"
  #   else
  #     echo "SSH key already exists, skipping generation."
  #   fi
  # '';
  programs = {
    ssh = {
      enable = true;
      # enableDefaultConfig = false;
      settings."*" = {
        IdentityFile = "~/.ssh/eakey";
        AddKeysToAgent = "yes";
      };
      #
    };
    # basic configuration of git, please change to your own
    git = {
      # enable = true;
      userName = "${username}";
      userEmail = "${username}@ea.se";
    };
    fish = {
      enable = true;
      shellInit = ''
        export fish_greeting=""
        export SHELL=fish
        # ssh-add ~/.ssh/eakey
      '';
      shellAbbrs = {
        ls = "exa";
        gs = "git status";
        giff = "git diff --color-words";
        cat = "bat";
        ipy = "ipython";
      };
      shellAliases = {
        py = "python";
        ll = "exa -l";
      };
      functions = {
        ssf = {
          body = "ssh $argv -t fish";
        };
      };
    };
    helix = {
      enable = true;
      defaultEditor = true;
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {command = "alejandra";};
          }
          {
            name = "python";
            auto-format = true;
            formatter = {
              command = "black";
              args = ["-q" "--fast" "-"];
            };
          }
        ];
      };
      settings = {
        # theme = "nightfox";
        keys.normal = {
          C-up = "expand_selection";
          C-down = "shrink_selection";
          C-left = "select_prev_sibling";
          C-right = "select_next_sibling";
        };
        editor = {
          cursor-shape = {
            insert = "bar";
          };
          line-number = "relative";
        };
      };
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
    # zellij = {
    #   enable = false;
    # };

    # Let home Manager install and manage itself.
    home-manager.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
      # written into .config/starship.toml
      settings = {
        add_newline = true;
        nix_shell = {
          impure_msg = "";
          format = "via [$symbol$state($name)]($style) ";
        };
      };
    };
  };
}
