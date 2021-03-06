#!/bin/sh -eux

rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?;
yum remove -y wget
yum clean all -y

rm -f /etc/udev/rules.d/70-persistent-net.rules
ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /dev/.udev/
