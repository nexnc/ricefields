{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable Ollama with ROCm acceleration
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    
    # Force ROCm to treat the 5700G Vega iGPU as a supported target (gfx900)
    rocmOverrideGfx = "9.0.0";
    
    loadModels = [ "llama3.2:3b" "qwen2.5-coder:7b" "deepseek-r1:8b" ];
  };

  users.users.ollama = {
    extraGroups = [ "render" "video" ];
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
