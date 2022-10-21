{ config, pkgs, lib, ... }: 
{
  config = lib.mkIf (config.powerManagement.cpuFreqGovernor != "performance") {
    #services.tlp.enable = true; #NOTE: conflict with services.power-profiles-daemon.enable


    #systemd.services = {
    #  powertop-auto-tune = {
    #    wantedBy = [ "multi-user.target" ];
    #    after = [ "multi-user.target" ];
    #    description = "Powertop tunings";
    #    path = [ pkgs.kmod ];
    #    serviceConfig = {
    #      Type = "oneshot";
    #      RemainAfterExit = "yes";
    #      ExecStart = ''
    #        ${pkgs.powertop}/bin/powertop --auto-tune
    #        HIDDEVICES=$(ls /sys/bus/usb/drivers/usbhid | grep -oE '^[0-9]+-[0-9\.]+' | sort -u)
    #        for i in $HIDDEVICES; do
    #          echo -n "Enabling " | cat - /sys/bus/usb/devices/$i/product
    #          echo 'on' > /sys/bus/usb/devices/$i/power/control
    #        done
    #      '';
    #    };
    #  };
    #};
  };#
}
