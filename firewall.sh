#!/bin/bash

IPT="/sbin/iptables"

## Flush and reset counters
$IPT -F
$IPT -X
$IPT -Z

## Loopback
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

## Accept ICMP Ping echo requests
$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

## Allow SSH (66022) from 69.236.265.20 only
$IPT -A INPUT -s 69.236.265.20 -p tcp -m tcp --syn --dport 66022 -j ACCEPT
$IPT -A INPUT -s 69.236.263.256 -p tcp -m tcp --syn --dport 66022 -j ACCEPT
$IPT -A INPUT -s 69.236.265.263 -p tcp -m tcp --syn --dport 66022 -j ACCEPT
$IPT -A INPUT -s 202.96.66.0/26 -p tcp -m tcp --syn --dport 66022 -j ACCEPT


##NRPE
$IPT -A INPUT -s 202.96.66.0/26 -p tcp -m tcp --syn --dport 5666 -j ACCEPT

##MYSQL-ndbd
$IPT -A INPUT -s 202.96.66.0/26 -p tcp -m tcp --syn --dport 2200 -j ACCEPT

## SNMP
$IPT -A INPUT -s 202.96.66.0/26 -p udp --dport 666 -j ACCEPT

## Allow inbound established and related outside communication
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## Drop outside initiated connections
$IPT -A INPUT -m state --state NEW -j REJECT

## Allow all outbound tcp, udp, icmp traffic with state
$IPT -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

## Chains
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP
