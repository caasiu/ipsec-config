#!/bin/bash
clear
set -e

echo "##############################################################"
echo "# Setup IPSec VPN for OpenVZ/Xen/KVM VPS on CentOS/Ubuntu"
echo "# Manual toturial: https://caasiu.github.io/ipsec-config"
echo "#"
echo "# Author: Caasiu Roger"
echo "#"
echo "##############################################################"
echo -e "\n"

function setup_ipsec(){
    check_vps
}

function check_vps(){
# only run this script as root
if [ $EUID -ne 0 ]
then
    echo "Error: This script must be run as root!"
else
    # check tun/tap support
    TunString="File descriptor in bad state"
    PPPString="No such device or address"

    if cat /dev/net/tun |& grep -q "$TunString"
    then
        if cat /dev/ppp |& grep -q "$PPPString"
        then
            echo "VPS can setup IPSec"
            echo -e "\n"

            get_vps_info
        else
            echo "Error: VPS does not support!"
        fi
    else
        echo "Error: VPS does not support!"
    fi
fi
}

function get_vps_info(){
    OS_Array=(CentOS Ubuntu)
    VI_Array=(OpenVZ Xen/KVM)

    # Users input their VPS information
    echo "VPS Operation System 1)CentOS or 2)Ubuntu"
    read -p "Your Choice (default=1): " OS_NO
    echo "VPS Virtualisation 1)OpenVZ or 2)Xen/KVM" 
    read -p "Your Choice (default=1): " VI_NO
    read -p "Input IP address(IPv4) of your VPS: " VPS_IP

    if [ $OS_NO -a $OS_NO == 2 ]
    then
        OS=${OS_Array[`expr $OS_NO - 1`]}
    else
        OS=${OS_Array[0]}
        OS_NO=1
    fi

    if [ $VI_NO -a $VI_NO == 2 ]
    then
        VI=${VI_Array[`expr $VI_NO - 1`]}
    else
        VI=${VI_Array[0]}
        VI_NO=1
    fi

    echo -e "\n"
    echo "############# VPS information #############"
    echo "VPS Operation System: [$OS]"
    echo "VPS Virtualization Infrastructure: [$VI]"
    echo "VPS IP Address: [$VPS_IP]"
    echo ""

    # VPS informations confirm
    read -p "Continue running this script?  [y/N] " CONFIRM

    if [ "$CONFIRM" == "y" ]
    then
        install_packages
    fi
}

function install_packages(){
    echo ""
    echo "Now download packages, please wait......"
    if [ ${OS_NO} == 1 ]
    then
        yum -y update
        yum -y install gmp-devel pam-devel openssl-devel libssl-dev make gcc
    elif [ ${OS_NO} == 2 ]
    then
        apt-get -y update
        apt-get -y install gmp-devel pam-devel openssl libssl-dev make gcc
    fi

    wget http://download.strongswan.org/strongswan.tar.bz2
    tar xjvf strongswan.tar.bz2

    precondition
}

function precondition(){
    echo ""
    echo "Now prepare the Strongswan installation"

    cd ./strongswan-*

    if [ $VI_NO == 1 ]
    then
        ./configure --prefix=/usr --sysconfdir=/etc \
            --enable-eap-mschapv2 --enable-xauth-eap --enable-eap-identity --enable-eap-tls \
            --enable-eap-ttls --enable-eap-md5 --enable-eap-tnc --enable-eap-dynamic \
            --enable-openssl --disable-gmp --enable-eap-aka --enable-nat-transport \
            --enable-kernel-libipsec 
    elif [ $VI_NO == 2 ]
    then
        ./configure --prefix=/usr --sysconfdir=/etc \
            --enable-eap-mschapv2 --enable-xauth-eap --enable-eap-identity --enable-eap-tls \
            --enable-eap-ttls --enable-eap-md5 --enable-eap-tnc --enable-eap-dynamic \
            --enable-openssl --disable-gmp --enable-eap-aka --enable-nat-transport 
    fi

    make && make install
    create_ca
}

function create_ca(){
    cd /etc/ipsec.d/

    # root CA
    ipsec pki --gen --type rsa --size 2048 \
                --outform pem \
                > private/ca.key.pem
    chmod 600 private/ca.key.pem
    ipsec pki --self --ca --lifetime 730 \
                --in private/ca.key.pem --type rsa \
                --dn "C=CN, O=strongSwan, CN=strongSwan Root CA" \
                --outform pem \
                > cacerts/ca.cert.pem

    # host CA
    ipsec pki --gen --type rsa --size 2048 \
              --outform pem \
              > private/host.key.pem
    chmod 600 private/host.key.pem
    ipsec pki --pub --in private/host.key.pem --type rsa | \
            ipsec pki --issue --lifetime 730 \
            --cacert cacerts/ca.cert.pem \
            --cakey private/ca.key.pem \
            --dn "C=CN, O=strongSwan, CN=${VPS_IP}" \
            --san ${VPS_IP} \
            --flag serverAuth --flag ikeIntermediate \
            --outform pem > certs/host.cert.pem

    # client CA
    ipsec pki --gen --type rsa --size 2048 \
              --outform pem \
              > private/client.key.pem
    chmod 600 private/client.key.pem
    ipsec pki --pub --in private/client.key.pem --type rsa | \
            ipsec pki --issue --lifetime 730 \
            --cacert cacerts/ca.cert.pem \
            --cakey private/ca.key.pem \
            --dn "C=CN, O=strongSwan, CN=myVPN" \
            --outform pem > certs/client.cert.pem

    echo ""
    echo "pkcs12 certification creation will ask for a password, which is for decode when install the pkcs12 CA on client"
    echo "password is optional, and four-words password is good for IOS device"
    echo "pkcs12 will store in /etc/ipsec.d/client.p12"
    echo ""
    #pkcs12 CA
    openssl pkcs12 -export -inkey private/client.key.pem \
        -in certs/client.cert.pem -name "myVPN CA" \
        -certfile cacerts/ca.cert.pem \
        -caname "strongSwan Root CA" \
        -out client.p12

}

function ipsec_configuration(){
    cd ~
    cat > /etc/ipsec.conf << "EOF"
# ipsec.conf - strongSwan IPsec configuration file
# basic configuration

config setup
    # strictcrlpolicy=yes
    uniqueids = never


conn %default
    keyexchange = ike
    
    dpdaction = clear
    dpddelay = 35s
    dpdtimeout = 300s


# for IOS 6+ and Android 4+ without install CA
conn IPSec-IKEv1-PSK
    keyexchange = ikev1
    fragmentation = yes
    
    #left -- local(server) side
    left = %any
    leftauth = psk
    leftsubnet = 0.0.0.0/0

    #right -- remote(client) side
    right = %any
    rightauth = psk
    rightauth2 = xauth
    rightsourceip = 10.36.1.0/24

    auto = add


# for IOS 8+ Android 4.4+ Win 7+
conn IPSec-IKEv2
    keyexchange = ikev2
    ike = aes256-sha1-modp1024,aes128-sha1-modp1024,3des-sha1-modp1024!
    esp = aes256-sha256,aes256-sha1,3des-sha1!
    eap_identity = %any
    fragmentation = yes
    rekey = no
    
    #left -- local(server) side
    left = %any
    leftauth = pubkey
    leftcert = host.cert.pem
    leftsubnet = 0.0.0.0/0
    leftsendcert = always

    #right -- remote(client) side
    right = %any
    rightauth = eap-mschapv2
    rightcert = client.cert.pem
    rightsourceip = 10.36.2.0/24
    rightsendcert = never

    auto = add

EOF

}

function strongswan_configuration(){
    cat > /etc/strongswan.conf << "EOF"
# /etc/strongswan.conf - strongSwan configuration file

charon {
    load_modular = yes
    duplicheck.enable = no #是为了你能同时连接多个设备，所以要把冗余检查关闭
    compress = yes
    plugins {
        include strongswan.d/charon/*.conf
                            
    }

    dns1 = 8.8.4.4
    dns2 = 8.8.8.8

    # for Windows WINS Server
    nbns1 = 8.8.4.4
    nbns2 = 8.8.8.8
}

include strongswan.d/*.conf

EOF

}

function secrets_configuration(){
    echo "Now configure the authrisation..."
    echo ""

    read -p "Input your Pre Share Key(the longer, the better): " PSK
    echo "##### Using IKEv1 + PSK #####"
    read -p "username for IKEv1: " pskUser
    while true; do
        read -p "password for ${pskPwd}: " pskPwd
        if [ -z "${pskPwd}" ]
        then
            echo "password can not be empty !"
            echo ""
        else
            break
        fi
    done

    echo ""
    echo "##### Using IKEv2 + EAP #####"
    echo "username and password have to be different with IKEv1+PSK"
    read -p "username for IKEv2: " eapUser
    while true; do
        read -p "password for ${eapUser}: " eapPwd
        if [ -z "${eapPwd}" ]
        then
            echo "password can not be empty !"
            echo ""
        else
            break
        fi
    done

    echo ""
    echo "You can change the username and password in /etc/ipsec.secrets"
    cat > /etc/ipsec.secrets <<-EOF
# /etc/ipsec.secrets

: RSA host.key.pem
: PSK "${PSK}"

# use XAUTH
#user1 : XAUTH "password1"
${pskUser} : XAUTH "${pskPwd}"

# use EAP
#user2 : EAP "password2"
${eapUser} : EAP "${eapPwd}"

EOF

}

function iptables_configuration(){
    sysctl -w net.ipv4.ip_forward=1
    sysctl -w net.ipv4.conf.all.accept_redirects=0 
    sysctl -w net.ipv4.conf.all.send_redirects=0

    ifconfig

    echo ""
    echo "Please enter the name of the interface which can be connected to the public network."
    echo "usually OpenVZ is venet0 and KVM/Xen is eth0"
    echo ""
    read -p "please input the interface" Interface

    if [ -z ${Interface} ]
    then
        if [ ${OS_NO} == 1 ]
        then
            iptables -A INPUT -i venet0 -p esp -j ACCEPT
            iptables -A INPUT -i venet0 -p udp --dport 500 -j ACCEPT
            iptables -A INPUT -i venet0 -p udp --dport 4500 -j ACCEPT
            iptables -t nat -A POSTROUTING -s 10.36.1.0/24 -o venet0 -j MASQUERADE
            iptables -t nat -A POSTROUTING -s 10.36.2.0/24 -o venet0 -j MASQUERADE
            iptables -A FORWARD -s 10.36.1.0/24  -j ACCEPT
            iptables -A FORWARD -s 10.36.2.0/24  -j ACCEPT
        elif [ ${OS_NO} ==2 ]
        then
            iptables -A INPUT -i eth0 -p esp -j ACCEPT
            iptables -A INPUT -i eth0 -p udp --dport 500 -j ACCEPT
            iptables -A INPUT -i eth0 -p udp --dport 4500 -j ACCEPT
            iptables -t nat -A POSTROUTING -s 10.36.1.0/24 -o eth0 -j MASQUERADE
            iptables -t nat -A POSTROUTING -s 10.36.2.0/24 -o eth0 -j MASQUERADE
            iptables -A FORWARD -s 10.36.1.0/24  -j ACCEPT
            iptables -A FORWARD -s 10.36.2.0/24  -j ACCEPT
        fi
    else
        iptables -A INPUT -i ${Interface} -p esp -j ACCEPT
        iptables -A INPUT -i ${Interface} -p udp --dport 500 -j ACCEPT
        iptables -A INPUT -i ${Interface} -p udp --dport 4500 -j ACCEPT
        iptables -t nat -A POSTROUTING -s 10.36.1.0/24 -o ${Interface} -j MASQUERADE
        iptables -t nat -A POSTROUTING -s 10.36.2.0/24 -o ${Interface} -j MASQUERADE
        iptables -A FORWARD -s 10.36.1.0/24  -j ACCEPT
        iptables -A FORWARD -s 10.36.2.0/24  -j ACCEPT
    fi

    ipsec start

    echo "setup success"
}

# run the main function
setup_ipsec
