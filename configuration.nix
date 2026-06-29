{pkgs, ...}: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  services = {
    xserver.videoDrivers = ["nvidia"];
  };

  # needed by nix-direnv
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  environment.systemPackages = with pkgs; [
  ];
  environment.sessionVariables = {
    LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"
    ];
  };
  system.stateVersion = "25.05";
  programs.ssh.startAgent = true;
}
