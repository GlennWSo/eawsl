{pkgs, ...}: {
  documentation.man.generateCaches = false;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    ssh.startAgent = true;
  };

  time.timeZone = "Europe/Stockholm";
  nix.settings = {
    trusted-users = ["gws"]; # I DONT BELONG HERE
    download-buffer-size = 512000000;
    # Compare to the key published at https://nix-community.org/cache
  };

  environment.systemPackages = with pkgs; [
    alejandra
    any-nix-shell
    bat
    btop
    direnv
    dufs
    eza
    fish
    gh
    git
    helix
    htop
    hwatch
    inetutils
    netcat
    nil
    nix-direnv
    openssl
    sshfs
    unzip
    zip
  ];

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };
}
