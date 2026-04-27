{
  portainer = {
    image = "portainer/portainer-ce:latest";
    autoStart = true;
    ports = [
      "9000:9000"  # HTTP Web UI
      "9443:9443"  # HTTPS Web UI
    ];
    volumes = [
      "portainer_data:/data"
      "/run/podman/podman.sock:/var/run/docker.sock:ro"
    ];
    extraOptions = [
      "--privileged"
    ];
  };
}
