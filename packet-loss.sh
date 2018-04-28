#!/bin/bash

{{/* =% sh %= */}}

{{ flag "ip1" "string" "IP1" | prompt "IP1?" "string" "172.31.30.198" | var `ip1`}}
{{ flag "ip2" "string" "IP2" | prompt "IP2?" "string" "172.31.31.86" | var `ip2`}}
{{ flag "ip3" "string" "IP3" | prompt "IP3?" "string" "172.31.17.169" | var `ip3`}}
{{ flag "loss" "int" "% loss" | prompt "% Packet loss?" "int" 50 | var `loss`}}
{{ flag "delay" "int" "msec delay" | prompt "Delay in msec" "int" 100 | var `delay`}}

interface=eth0
ip1={{ var `ip1` }}
ip2={{ var `ip2` }}
ip3={{ var `ip3` }}

delay={{- var `delay` -}}ms
loss={{- var `loss` -}}%

$(logger "PACKET-LOSS: packet loss at {{ var `loss` }}%, IP list = [{{var `ip1`}}, {{var `ip2`}}, {{var `ip3`}}]")

sudo tc qdisc add dev $interface root handle 1: prio
sudo tc filter add dev $interface parent 1:0 protocol ip prio 1 u32 match ip dst $ip1 flowid 2:1
sudo tc filter add dev $interface parent 1:0 protocol ip prio 1 u32 match ip dst $ip2 flowid 2:1
sudo tc filter add dev $interface parent 1:0 protocol ip prio 1 u32 match ip dst $ip3 flowid 2:1
#sudo tc qdisc add dev $interface parent 1:1 handle 2: netem delay $delay
sudo tc qdisc add dev $interface parent 1:1 handle 2: netem loss $loss
