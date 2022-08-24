{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    ntfs3g #微软NTFS文件系统支持
  ];
}
