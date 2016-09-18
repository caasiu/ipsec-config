# ipsec-config

* A Chinese guide for IPSec IKEv1/v2 VPN setup on CentOS/Ubuntu VPS
* 在 CentOS/Ubuntu 使用Strongswan架设IPSec IKEv1/v2 VPN 教程

## Manual Setup

手动设置(推荐)

参考教程： https://caasiu.github.io/ipsec-config

## Quick Setup

Use the ipsec-setup.sh script. Check the [source](ipsec-setup.sh) 

Download using wget:
```
wget --no-check-certificate https://raw.githubusercontent.com/caasiu/ipsec-config/master/ipsec-setup.sh
```

Then run the script as root:
```
sudo bash ipsec-setup.sh
```
