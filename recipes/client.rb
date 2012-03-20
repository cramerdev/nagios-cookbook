#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: client
#
# Copyright 2009, 37signals
# Copyright 2009-2011, Opscode, Inc
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

mon_host = node['nagios']['server']['ipaddresses']
# Get all of the ip addresses for a node
mon_hosts_for = lambda do |n|
  n['network']['interfaces'].map {|iface| iface[1]['addresses'].keys }.flatten
end


# Get all the mon host ips
if node.run_list.roles.include?(node['nagios']['server_role'])
  mon_host.concat(mon_hosts_for.call(node)).uniq
else
  search(:node, "role:#{node['nagios']['server_role']}") do |n|
    mon_host.concat(mon_hosts_for.call(n)).uniq
  end
end

include_recipe "nagios::client_#{node['nagios']['client']['install_method']}"

service "nagios-nrpe-server" do
  action :enable
  supports :restart => true, :reload => true
end

remote_directory node['nagios']['plugin_dir'] do
  source "plugins"
  owner "root"
  group "root"
  mode 0755
  files_mode 0755
end

template "#{node['nagios']['nrpe']['conf_dir']}/nrpe.cfg" do
  source "nrpe.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :mon_host => mon_host,
            :ip       => node['nagios']['client']['nrpe_bind_address']
  notifies :restart, "service[nagios-nrpe-server]"
end
