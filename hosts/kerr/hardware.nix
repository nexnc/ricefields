{ config, pkgs, ... }:
{
  # AMD GPU
  hardware = {
    i2c.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };

  # Data drive mount
  fileSystems."/mnt/Data" = {
    device = "UUID=d60c75ae-fc6a-4491-b591-91397bd46aaf";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # Vulkan AMD environment
  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };
}
