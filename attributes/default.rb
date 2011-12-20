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

# Set client IP
#
# Use the public ip for Rackspace Cloud Servers
if node['cloud'] && node['cloud']['provider'] == 'rackspace'
  default['nagios']['client']['ipaddress'] = node['cloud']['public_ipv4']
# Use the private ip for other "cloud"-like providers
elsif node['cloud'] && node['cloud']['local_ipv4']
  default['nagios']['client']['ipaddress'] = node['cloud']['local_ipv4']
# Or the regular ip
else
  default['nagios']['client']['ipaddress'] = node['ipaddress']
end
