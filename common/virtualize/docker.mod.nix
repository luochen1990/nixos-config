{ config, pkgs, lib, ... }: 
{
  config = {
    # Enable Docker
    # virtualisation.docker.enable = true;

    # Enable Podman & Docker alias
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
  };
}
