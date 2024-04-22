#!/bin/sh

uci del dhcp.cfg01411c.server
uci add_list dhcp.cfg01411c.server='/server/192.168.0.1'
uci add_list dhcp.cfg01411c.server='/lan/192.168.0.1'
uci add_list dhcp.cfg01411c.server='/local/192.168.0.1'
uci add_list dhcp.cfg01411c.server='192.168.0.30'
uci commit dhcp
service dnsmasq restart
