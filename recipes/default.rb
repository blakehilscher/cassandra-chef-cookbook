include_recipe "cassandra::datastax"

if node["cassandra"]["seeds_by_role"]
  # look up cass nodes
  cassandra_nodes = search(:node, "role:#{node["cassandra"]["seeds_by_role"]} AND chef_environment:#{node.chef_environment}") || []
  # assign nodes as seeds
  node["cassandra"]["seeds"] = cassandra_nodes.collect{|cn| cn['local_ipv4'] }
end

%w(cassandra.yaml cassandra-env.sh).each do |f|
  template File.join(node["cassandra"]["conf_dir"], f) do
    source "#{f}.erb"
    owner node["cassandra"]["user"]
    group node["cassandra"]["user"]
    mode  0644
    notifies :restart, resources(:service => "cassandra")
  end
end
