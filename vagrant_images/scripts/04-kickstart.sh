#!/bin/sh -eux

# network
cat << 'EOF' > /etc/sysconfig/network
NETWORKING=yes
#NETWORKING_IPV6=yes
HOSTNAME=localhost.localdomain
EOF

cat << 'EOF' > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
BOOTPROTO="dhcp"
ONBOOT="yes"
EOF

# cat << 'EOF' > /etc/resolv.conf
# nameserver 133.242.0.3
# nameserver 133.242.0.4
# #nameserver 2403:3a00::1
# EOF

cat >> /etc/sysctl.conf <<-EOF

# Do not accept RA
net.ipv6.conf.default.accept_ra=0
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.eth0.accept_ra=0
EOF

# Add elrepo&epel Repository
yum -y localinstall http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
perl -pi.orig -e 's/^(mirrorlist=)/#$1/; s/^#(baseurl=)/$1/' /etc/yum.repos.d/CentOS-Base.repo
perl -pi -e 's/^(baseurl=http:\/\/mirror.centos.org)/baseurl=http:\/\/ftp.sakura.ad.jp\/pub\/linux/' /etc/yum.repos.d/CentOS-Base.repo

# ntp
cat <<'EOF' >/etc/ntp.conf
# For more information about this file, see the man pages
# ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).

driftfile /var/lib/ntp/drift

# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
restrict -4 default ignore
restrict -6 default ignore
restrict ntp1.sakura.ad.jp kod nomodify notrap nopeer noquery
#restrict -6 ntp1.sakura.ad.jp kod nomodify notrap nopeer noquery

disable monitor

# Permit all access over the loopback interface.  This could
# be tightened as well, but to do so would effect some of
# the administrative functions.
restrict -4 127.0.0.1
restrict -6 ::1

# Hosts on local network are less restricted.
#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap

# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
server ntp1.sakura.ad.jp iburst

#broadcast 192.168.1.255 autokey        # broadcast server
#broadcastclient                        # broadcast client
#broadcast 224.0.1.1 autokey            # multicast server
#multicastclient 224.0.1.1              # multicast client
#manycastserver 239.255.254.254         # manycast server
#manycastclient 239.255.254.254 autokey # manycast client

# Enable public key cryptography.
#crypto

includefile /etc/ntp/crypto/pw

# Key file containing the keys and key identifiers used when operating
# with symmetric key cryptography.
keys /etc/ntp/keys

# Specify the key identifiers which are trusted.
#trustedkey 4 8 42

# Specify the key identifier to use with the ntpdc utility.
#requestkey 8

# Specify the key identifier to use with the ntpq utility.
#controlkey 8

# Enable writing of statistics records.
#statistics clockstats cryptostats loopstats peerstats
EOF

# chrony
cat <<'EOF' >/etc/chrony.conf
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
server ntp1.sakura.ad.jp iburst

# Ignore stratum in source selection.
stratumweight 0

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# In first three updates step the system clock instead of slew
# if the adjustment is larger than 10 seconds.
makestep 10 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Allow NTP client access from local network.
#allow 192.168/16

# Listen for commands only on localhost.
bindcmdaddress 127.0.0.1
bindcmdaddress ::1

# Serve time even if not synchronized to any NTP server.
#local stratum 10

# Specify file containing keys for NTP and command authentication.
keyfile /etc/chrony.keys

# Specify key number for command authentication.
commandkey 1

# Generate new command key on start if missing.
generatecommandkey

# Disable logging of client accesses.
noclientlog

# Send message to syslog when clock adjustment is larger than 0.5 seconds.
logchange 0.5

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking

# This option allows you to configure the port on which chronyd will listen for NTP requests.
# The compiled in default is udp/123, the standard NTP port. If set to 0, chronyd will not open the server
# socket and will operate strictly in a client-only mode.
port 0

# User to which will chronyd switch on initialisation to drop root privileges.
user chrony

# Deny access to chronyc from other computers.
cmddeny all

# Lock chronyd into RAM so that it will never be paged out.
lock_all
EOF

# sshd
sed -i -e "/\#MaxSessions 10$/a #AllowUsers\nDenyUsers toor administrator administrateur admin adm test guest info mysql user oracle" /etc/ssh/sshd_config
sed -i -e '/GSSAPIAuthentication yes$/d' /etc/ssh/sshd_config
sed -i -e '/^GSSAPICleanupCredentials yes$/d' /etc/ssh/sshd_config

# fail2ban
touch /var/log/fail2ban.log
sed -i -E 's/^(logtarget =).*/\1 \/var\/log\/fail2ban.log/' /etc/fail2ban/fail2ban.conf

# fail2ban local.conf
cat <<'EOL' >/etc/fail2ban/jail.d/local.conf
[DEFAULT]
banaction = firewallcmd-ipset
backend = systemd

[sshd]
enabled = true
EOL

#locale
cat <<'EOF' > /etc/locale.conf
LANG="ja_JP.UTF-8"
EOF

# postfix
sed -i -e 's/^#mynetworks_style = host$/mynetworks_style = host/' /etc/postfix/main.cf

# grub
sed -i -e 's/"crashkernel=auto rhgb quiet"/"consoleblank=0 net.ifnames=0 biosdevname=0\"/g' /etc/default/grub
grub2-mkconfig -o /etc/grub2.cfg

# autofsck
echo 'AUTOFSCK_DEF_CHECK=yes' >> /etc/sysconfig/autofsck

# yum install -y gdisk
# sgdisk -t 3:8300 /dev/sda
# gdisk -l /dev/sda

# yum update
yum -y clean all
yum -y update

# udev
rm -f /etc/udev/rules.d/70-persistent-net.rules
