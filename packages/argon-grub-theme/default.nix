#Ref: https://gitlab.com/VandalByte/darkmatter-grub-theme/-/blob/main/flake.nix
#Doc: https://github.com/stuarthayhurst/argon-grub-theme
#NOTE: not working yet, need debuging
{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "argon-grub-theme";
  src = pkgs.fetchFromGitHub ({
    owner = "stuarthayhurst";
    repo = "argon-grub-theme";
    rev = "v3.3.1";
    sha256 = "sha256-sAF3bm+FL7fQEneIEuvaFyOXCRTuRnyg9Bp+cFrYn/U=";
  });
  installPhase = ''
    mkdir -p $out/
    cp -r assets/* $out/
  '';
}
