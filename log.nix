{config, ...}: {
  services.vector = {
    enable = true;
    journaldAccess = false;
    settings = {
      sources.http_in = {
        type = "http";
        address = "0.0.0.0:6767";
      };
      sinks.file_out = {
        type = "file";
        inputs = ["http_in"];
        path = "/var/log/vector/http_messages.log";
        # This ensures it prints just the raw body string followed by a newline (\n)
        encoding.codec = "text";
      };
    };
  };
  systemd.services.vector.serviceConfig.LogsDirectory = "vector";
  networking.firewall.allowedTCPPorts = [6767];
}
