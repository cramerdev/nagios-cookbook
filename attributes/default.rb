#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Attributes:: default
#
# Copyright 2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['nagios']['user'] = "nagios"
default['nagios']['group'] = "nagios"

set['nagios']['plugin_dir'] = "/usr/lib/nagios/plugins"

# Set server ips
default['nagios']['server']['ipaddresses'] = []

# Set client and NRPE IPs
#
# If we have cloud attributes, decide using those
if node['cloud'] && Array(node['cloud']['public_ipv4']).any?
  public_ipv4 = Array(node['cloud']['public_ipv4']).first
  local_ipv4 = Array(node['cloud']['local_ipv4']).first

  # Use the public ip for the client address
  default['nagios']['client']['ipaddress'] = public_ipv4

  # A public ip that's the same as the node's IP, like stock rackspace cloud
  # servers
  if public_ipv4 == node['ipaddress']
    default['nagios']['client']['nrpe_bind_address'] = node['ipaddress']
  # If the node IP address is the same as the cloud private address, bind to
  # that
  elsif local_ipv4 == node['ipaddress']
    default['nagios']['client']['nrpe_bind_address'] = local_ipv4
  end

# If we don't have a cloud attribute, just use the node ipaddress
else
  default['nagios']['client']['ipaddress'] = node['ipaddress']
  default['nagios']['client']['nrpe_bind_address'] = node['ipaddress']
end
