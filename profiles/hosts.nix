{ config, pkgs, ... }:
{
  networking.hosts = {
    "172.16.4.254" = ["xs"]; #xrail
    "172.16.4.252" = ["xrailvm"];
    "10.12.0.46" = ["intranet.groupesl.com"];
    "167.99.27.107" = ["stage.myvibe.life" "master.myvibe.life"];
    "157.230.74.252" = ["prod.myvibe.life"];
    "104.27.157.125" = ["production.myvibe.life"];
    "172.16.100.250" = ["ergo.test"];
    "192.168.122.42" = ["jira.xrailtest.com" "test.xrailtest.com"];
    "192.168.122.16" = ["gsl-intranet-db.local"];
    "192.168.122.150" = ["gsl-intranet-services.local"];
    #"75.119.217.153" = ["observateur.qc.ca" "www.observateur.qc.ca" "zoneclient.observateur.qc.ca"];
    #"192.168.122.57" = ["transportmmd.ca" "www.transportmmd.ca"];
  };
}
