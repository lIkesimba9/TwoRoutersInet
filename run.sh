#!/bin/bash

# create virtual ethernet link: veth0 <--> veth1
sudo ip link add veth0 type veth peer name veth1

# veth0 <--> veth1 link uses 192.168.2.x addresses
sudo ip addr add 192.168.2.2 dev veth1

# bring up both interfaces
sudo ip link set veth0 up
sudo ip link set veth1 up

# disable CRC offloading to hardware
sudo ethtool --offload veth0 tx off rx off
sudo ethtool --offload veth1 tx off rx off

# add routes for new link
sudo route add -net 192.168.2.0 netmask 255.255.255.0 dev veth1
sudo route add -net 10.2.0.0 netmask 255.255.0.0 dev veth1 gateway 192.168.2.1

echo "COFIGURE virtual HOST"
### create my int ###
sudo ip netns add host1
echo "create namespace host1"

sudo ip link add dev veth2 type veth peer name veth3
echo "add link veth2 <--> veth3"


sudo ip link set veth2 netns host1
echo "add veth2 in namespace host1"

sudo ip link set veth3 netns host1
echo "add veth3 in namespace host1"
sudo ip netns exec host1 ip link set veth2 up
sudo ip netns exec host1 ip link set veth3 up
sudo ip netns exec host1 ip addr add 10.2.1.2 dev veth3
echo "set veth3 ip address 10.2.1.2"

sudo ip netns exec host1 ethtool --offload veth2 tx off rx off
sudo ip netns exec host1 ethtool --offload veth3 tx off rx off
echo "ethtool"

sudo ip netns exec host1 route add -net 10.2.1.0 netmask 255.255.255.0 dev veth3
sudo ip netns exec host1 route add -net 192.168.2.0 netmask 255.255.255.0 dev veth3 gateway 10.2.1.254 
echo "add route"
# traceroute
#tracepath 10.2.1.1 &

# run simulation
#inet_dbg -u Cmdenv

# destroy virtual ethernet link
#sudo ip link del veth0