#
# Cookbook Name:: cassandra
# Recipe:: datastax
#
# Copyright 2011-2012, Michael S Klishin & Travis CI Development Team
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

# This recipe relies on a PPA package and is Ubuntu/Debian specific. Please
# keep this in mind.

apt_repository "datastax" do
  uri          "http://debian.datastax.com/community"
  distribution "stable"
  components   ["main"]
  key          "http://debian.datastax.com/debian/repo_key"

  action :add
end

# DataStax Server Community Edition package will not install w/o this
# one installed. MK.
package "python-cql" do
  action :install
  options("--force-yes")
end

bash "install package cassandra" do
  user "root"
  code %Q{apt-get -q -y --force-yes install #{node.cassandra.package}=#{node.cassandra.version}-1 cassandra=#{node.cassandra.version} -o Dpkg::Options::="--force-confdef"}
end

service "cassandra" do
  action :stop
end

# ensure data_root_dir exists
directory node.cassandra.data_root_dir do
  owner node.cassandra.user
  group node.cassandra.user
  mode 0755
  action :create
end

bash "ensure correct permissions on data_root_dir, commitlog_dir, log_dir" do
  user "root"
  code [
    "chown -R #{node.cassandra.user}:#{node.cassandra.user} #{node.cassandra.data_root_dir}",
    "chown -R #{node.cassandra.user}:#{node.cassandra.user} #{node.cassandra.commitlog_dir}",
    "chown -R #{node.cassandra.user}:#{node.cassandra.user} #{node.cassandra.log_dir}",
  ].join(';')
end

# if node.cassandra.seeds_by_role == false
#   seeds = node.cassandra.seeds
# else
#   seeds = search(:node, "role:#{node["cassandra"]["seeds_by_role"]} AND chef_environment:#{node.chef_environment} NOT hostname:#{node['hostname']}").collect{|h| h['ipaddress'] } || []
# end

seeds = node.cassandra.seeds

%w(cassandra.yaml cassandra-env.sh).each do |f|
  template File.join(node["cassandra"]["conf_dir"], f) do
    source "#{node.cassandra.package}/#{f}.erb"
    owner node["cassandra"]["user"]
    group node["cassandra"]["user"]
    mode  0644
    variables :seeds => seeds
  end
end