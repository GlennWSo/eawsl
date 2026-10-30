{pkgs, ...}: {
  systemd.services.monitor-service-storage = {
    description = "Monitor storage usage for isolated service directories";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "track-dirs" ''
        LOG_FILE="/var/log/service_storage_trends.log"
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

        # Target directories to log disk use of
        TARGETS=(
          "/var/lib"
          "/var/log"
        )

        for DIR in "''${TARGETS[@]}"; do
          if [ -d "$DIR" ]; then
            SIZE=$(${pkgs.coreutils}/bin/du -s -k "$DIR" | ${pkgs.coreutils}/bin/cut -f1)
            echo "$TIMESTAMP | $DIR | ''${SIZE}KiB" >> "$LOG_FILE"
          fi
        done
      '';
    };
  };

  systemd.timers.monitor-service-storage = {
    wantedBy = ["timers.target"];
    timerConfig = {
      # OnCalendar = "daily";
      OnCalendar = "hourly";
      Persistent = true;
    };
  };

  services.sysstat = {
    enable = true;
    collect-frequency = "*:*:00";
    # Crucial fix: Passing "-S DISK" forces sa1 to collect block device data
    collect-args = "-S DISK 1 1";
  };

  environment.systemPackages = [
    pkgs.sysstat
  ];
}
