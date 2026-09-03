{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable Ollama with ROCm acceleration
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    
    # Environment variables required for Vega 8 iGPU offloading
    environmentVariables = {
      GGML_VK_VISIBLE_DEVICES = "0";
      OLLAMA_IGPU_ENABLE = "1";
      OLLAMA_ORIGINS = "*";
    };
    
    loadModels = [ "llama3.2:3b" "qwen2.5-coder:7b" "deepseek-r1:8b" ];
  };

  users.users.ollama = {
    extraGroups = [ "render" "video" ];
    isNormalUser = true;
  };

  services.open-webui = {
    enable = true;
    port = 8080;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
