{ config, pkgs, lib, ... }: 
{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Podman
  virtualisation.podman.enable = true;
  #virtualisation.podman.dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement

  users.users.${config.owner}.extraGroups = lib.mkIf config.virtualisation.docker.enable [ "docker" ];
}
