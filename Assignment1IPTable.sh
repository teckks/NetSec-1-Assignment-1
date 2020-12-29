#!/bin/bash

##User Config
TCP_Ports="53","443","22","80"
UDP_Ports="443","53","67","68" 
HTTP_Port="80"
ReservedPort="0"
BlockedPorts="0:1023"
#BlockedPort="9999"

##Flush
iptables -F
iptables -X

##Setting Default Policies to DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

##Creating user-defined chains
iptables -N dnsdhcp
iptables -N drop
iptables -N dropout

##Allow these  ports
iptables -A dnsdhcp -p tcp --match multiport --sport $TCP_Ports -j ACCEPT
iptables -A dnsdhcp -p tcp --match multiport --dport $TCP_Ports -j ACCEPT
iptables -A dnsdhcp -p udp --match multiport --sport $UDP_Ports -j ACCEPT
iptables -A dnsdhcp -p udp --match multiport --dport $UDP_Ports -j ACCEPT

##Dropping traffic to www from source ports less than 1024
iptables -A drop -p tcp --dport $HTTP_Port --match multiport --sports $BlockedPorts -j DROP

##Dropping packets from reserved + outbound traffic to 0
iptables -A drop -p tcp --sport $ReservedPort -j DROP
iptables -A drop -p tcp --dport $ReservedPort -j DROP

#iptables -A dropout -p tcp --match multiport --sport $BlockedPort -j DROP
#iptables -A dropout -p tcp --match multiport --dport $BlockedPort -j DROP

##Adding user-defined chains
#iptables -A INPUT -j dropout
#iptables -A OUTPUT -j dropout
iptables -A INPUT -j drop
iptables -A OUTPUT -j drop
iptables -A INPUT -j dnsdhcp
iptables -A OUTPUT -j dnsdhcp
 
