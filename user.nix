{username ? "ea", ...}: {
  users.users = {
    ${username} = {
      isNormalUser = true;
      description = "${username}";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "kvm"];
      # generate hash with mkpasswd: `echo `
      hashedPassword = "$y$j9T$ExBYiJQRORac0MHgPi1y5/$mKKbeYhGa80tsZmHSA0V0hE7KmxvYGfwsh3vndUi0e5";
    };
  };

  nix.settings.trusted-users = [username];
}
