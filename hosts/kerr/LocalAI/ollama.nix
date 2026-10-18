{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable Ollama with Vulkan
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    
    # Environment variables required for Vega 8 iGPU offloading
    environmentVariables = {
      GGML_VK_VISIBLE_DEVICES = "0";
      OLLAMA_IGPU_ENABLE = "1";
      OLLAMA_ORIGINS = "*";
    };
    
    loadModels = [ ];
  };

  users.users.ollama = {
    extraGroups = [ "render" "video" ];
    isNormalUser = true;
  };

  services.open-webui = {
    enable = true;
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
