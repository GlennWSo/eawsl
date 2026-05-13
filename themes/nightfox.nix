{
  pkgs,
  inputs,
  config,
  ...
}: let
  nightfoxBase16text = ''
    system: "base16"
    name: "nightfox"
    author: "EdenEast (https://github.com/EdenEast/nightfox.nvim)"
    variant: "dark"
    palette:
      base00: "192330" # ----
      base01: "212e3f" # ---
      base02: "29394f" # --
      base03: "575860" # -
      base04: "71839b" # +
      base05: "cdcecf" # ++
      base06: "aeafb0" # +++
      base07: "e4e4e5" # ++++
      base08: "c94f6d" # red
      base09: "f4a261" # orange
      base0A: "dbc074" # yellow
      base0B: "81b29a" # green
      base0C: "63cdcf" # aqua/cyan
      base0D: "719cd6" # blue
      base0E: "9d79d6" # purple
      base0F: "d67ad2" # brown
  '';
  nightfoxFile = builtins.toFile "nightfox.yaml" nightfoxBase16text;
  # unstable = import inputs.unstable {
  #   system = config.nixpkgs.buildPlatform.system;
  # };
in {
  fonts = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget

    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      # (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "SourceCodePro" "Tinos"];})
      nerd-fonts."fira-code"
      nerd-fonts."droid-sans-mono"
      # # nerd-fonts."SourceCodePro"
      nerd-fonts."tinos"
    ];
  };
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/images6/Cool-Astronaut-HD-Wallpaper-Beer.jpg";
      sha256 = "crOIM6li5jDHzKObE9QCOgLwKaVDdf8d6rJ3sLCQgFU=";
    };
    # polarity = "dark";
    base16Scheme = nightfoxFile;
    # base16Scheme = "${inputs.tt-schemes}/base16/helios.yaml";
    # base16Scheme = "${inputs.tt-schemes}/base16/nord.yaml";
    fonts = {
      sizes = {
        desktop = 12;
        applications = 16;
        terminal = 16;
      };
    };
  };
}
