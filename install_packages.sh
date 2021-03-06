#!/usr/bin/env bash
#
# SPDX-License-Identifier: Apache-2.0
#
#

# install_packages.sh - install required packages

sudo apt-get install virt-manager libvirt-bin qemu-system -y

cat << EOF | sudo tee /etc/libvirt/qemu.conf
user = "root"
group = "root"
EOF

sudo service libvirt-bin restart
