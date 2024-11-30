{config, pkgs, ...}:
{
  users.users.twistedjoe = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "storage" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp" "adbusers" "docker"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgm4SslljVjQqdXEGfSTMi9K+Tai/nS4tPSP8fxwwcZ4efIEe4JtiD54HEoFcyFNe0y5uXExeWUcHwwm6/AkRYasbLa9HPJ/Pu0sqMiuqi6mVZhI00H8jAaunZC4z6HpgtDUJzfkUPcaEuGnDJT1OpqFt5mpgwZ+1WTXPqcWWmLIyVjycl4Iye1aQ1CuSY/adR3TDU4a0bZO5r5kwI63i/dorArgUqx84wvUvJNlD7KVMQtEvBw8ajkeIpC8fVN21/29xU1a60gq8hH8mRz08/N+wKLlC2+DpsZOScvNaXwZnRI4Dmz5Gv05J/L1TYt5jOL6tiBj1jIrFeM5bbVMVX twistedjoe@birdperson"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC88Aa8pa+YKCVwxYUD8W5/9L508JnuIiA3Qpo48vdTik3PRHQlA4yzfHpqkJQi4r/veWINRPSIFLQrCTvmPeQjjZ7sbyfTMyxiwFq3de541qP/hwBShn7wwGOO018GZy0Wf8NSjseEuLHa8kxiMByxZYIKctz+P4SwyJayBGey2ijXNFonQW3M5Tn05X11QboXUfJ2SunfJHFcvyUyML4uc7DshZA/ntdn7F6LS67HkCMzOSp9mOxaJvo1W38ZQiNsoSiYP03uTLBR198TsVK9bT+H0KB8Sh1sPFUp0cIMk9c+iy5MVKLYe0R0TJ8CJIUHSdpTloNBvtuQcwRJfROY71u2sZPYSJv+/9H+tykMw+0mI6Jfl+PCRCIqn1X8VRMPXwREF0TCFYuBoKUhT+XeSKWky1m893KvT0eChY0Go7z8wc4KVOBqd/QWC81K9P8X02Xq/0ICFedcUc1Li5VtXZ9j9pPyWcTyeLR+9+WnfHYbL+LZof8072fEEu4iWKM= twistedjoe@butter-robot"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCBlEfsUxFsoed9khhPhQZTfoDyePFNHo03QZPS3DnmQ9Y33zPlTds09n3ilXV26Sn/6lRGe+Dz9Eyk2JDKrvQ3+/Gltb+VaD0Hp2bH+4C/DGj4Fnw9mf98gfBfUrqhd/LkSevDBMRNohl2rHti/BbQZihRhMi0R7E+ui0csGbyxaHhsKKOjjpHEQbzlkHYPNcvth4OieOdsZIdWoTGj0ZsdEOMhrHtJn8P3qoGxCJZ0YAHwJUqocHVIqOhzWhFJ/ibPQSVB5fDROb2NJBBtdUX74hmTKsT64MZQ1/vUIqKgxRmey/TdjcUTwjuzXk7jh/mv1mGPCsnuECRclESBNn twistedjoe@squanchy"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkFM001QJeFnhB75BRFvwm0xRDBiDmQZP4bNRstK1DIOCpShk91/iK+FUgVxVKp5n4Z925FJh33TDeLYm/F7vQLuJiaa/dRWtVTnIsdAPPQGB+1iFDt5bpBwaCqBUV6mNcAYQu4op1Fy8dzT0ruasic2hrD7sNlIYPpX7lpGX8o1oKhasBZ5ExKGmIKhAlOdSCxVmFmgPHFjFqM9dkNfi+hjWf4BPTkXPVry2zhDcnl4aiyY04FcanMsXcpE75q8FCeKfrvbc1xQQp/Ol/29nuv+Pnb0r7500CFAkQnRd3RxGBa9IS9P+Urbw7ttsxHjEwJ1nnYT31wuoBcWrdeMpj JuiceSSH"
    ];
  };
}
