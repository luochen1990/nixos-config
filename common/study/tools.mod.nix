{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    zotero
    mendeley
  ];
}
