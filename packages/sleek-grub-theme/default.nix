#Ref: https://gitlab.com/VandalByte/darkmatter-grub-theme/-/blob/main/flake.nix
{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "sleek-grub-theme";
  src = pkgs.fetchFromGitHub ({
    #owner = "sandesh236";
    owner = "luochen1990";
    repo = "sleek--themes";
    rev = "8722b781f5c9d8ef60a98183484c24cfbce2dedd";
    sha256 = "sha256-B+0wPEksHqbnBdZBNZUtW7vv73b4PT12W5RaPQ2Q4Hc=";
  });
  installPhase = ''
    mkdir -p $out/

    cp -r 'Sleek theme-dark'/sleek/* $out/
    sed -i "s/Grub Bootloader/Hello LC/" $out/theme.txt
  '';
}
