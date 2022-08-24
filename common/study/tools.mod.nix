{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    mendeley
  ];
}
