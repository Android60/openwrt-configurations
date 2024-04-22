#!/bin/sh

# This script is executed by cron every minute

# Set vars
piholeDNS='192.168.0.30'
backupDNS='192.168.100.1'
testDomain='www.google.com'
currentDNS="$(uci show dhcp.cfg01411c.server)"


# Check if PiHole DNS is used already
if [[ "$currentDNS" == *"$piholeDNS"* ]]; then
  echo "Current DNS is PiHole"
  if nslookup $testDomain $piholeDNS ; then
      echo "PiHole test OK"
  else
#     echo "PiHole test failed, setting to backupDNS"
      logger -t cron.info PiHole test failed, setting to backupDNS
      uci del dhcp.cfg01411c.server
      uci add_list dhcp.cfg01411c.server='/server/192.168.0.1'
      uci add_list dhcp.cfg01411c.server='/lan/192.168.0.1'
      uci add_list dhcp.cfg01411c.server='/local/192.168.0.1'
      uci add_list dhcp.cfg01411c.server='192.168.100.1'
      uci commit dhcp
      service dnsmasq restart
  fi
else
  echo "Current DNS is ISP"
  if nslookup $testDomain $piholeDNS ; then
#     echo "PiHole test OK, switching to PiHole"
      logger -t cron.info PiHole test OK, switching to PiHole
      uci del dhcp.cfg01411c.server
      uci add_list dhcp.cfg01411c.server='/server/192.168.0.1'
      uci add_list dhcp.cfg01411c.server='/lan/192.168.0.1'
      uci add_list dhcp.cfg01411c.server='/local/192.168.0.1'
      uci add_list dhcp.cfg01411c.server='192.168.0.30'
      uci commit dhcp
      service dnsmasq restart
  fi
fi
