#!/usr/bin/env bash
usage() {
    echo "$0 [-h]"
    echo ""
    echo "Options:"
#    echo "  -i: Harvester HCI ISO image"
    echo ""
}

while getopts "i:" o; do
    case "${o}" in
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

BRIDGE_INTERFACE=${BRIDGE_INTERFACE:-hcibr}
EXTERNAL_NETWORK=${EXTERNAL_NETWORK:-172.16.0.0/24}
EXTERNAL_IP=${EXTERNAL_IP:-172.16.0.1/24}

if [[ -r /sys/class/net/${BRIDGE_INTERFACE}1 ]]; then
    echo "${BRIDGE_INTERFACE}1 exists, cowardly refusing to overwrite it, exiting..."
    exit 1
fi

for i in {1..4}; do
    sudo ip link add ${BRIDGE_INTERFACE}$i type bridge
done

sudo ip addr add $EXTERNAL_IP dev ${BRIDGE_INTERFACE}1
sudo ip link set ${BRIDGE_INTERFACE}1 up
sudo ip link set ${BRIDGE_INTERFACE}2 up
sudo ip link set ${BRIDGE_INTERFACE}3 up
sudo ip link set ${BRIDGE_INTERFACE}4 up
sudo iptables -t nat -A POSTROUTING -s $EXTERNAL_NETWORK -j MASQUERADE
