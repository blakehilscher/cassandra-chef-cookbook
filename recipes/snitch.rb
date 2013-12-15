if node.cassandra.snitch == 'PropertyFileSnitch'
  
  cass_nodes = search(:node, "role:quandl_cassandra AND chef_environment:#{node.chef_environment}") || []
  cass_nodes = cass_nodes.group_by{|n| n.ec2.placement_availability_zone }
  cass_nodes = cass_nodes.collect do |zone, cnodes|
    cnodes.collect do |cnode|
      # get the datacenter
      datacenter = node.cassandra.availability_zones[zone]
      # get the rack
      rack = cnode.name.split('-').last.split('.').first
      "#{cnode.ipaddress}=#{datacenter}:rac#{rack}"
    end
  end.flatten

  template File.join(node["cassandra"]["conf_dir"], "cassandra-topology.properties") do
    source "cassandra-topology.properties.erb"
    owner node.cassandra.user
    group node.cassandra.user
    mode  0644
    variables :cass_nodes => cass_nodes
  end
  
  service "cassandra" do
    action :restart
  end
  
end

if node.cassandra.snitch == 'GossipingPropertyFileSnitch'
  
  datacenter = node.cassandra.availability_zones[zone]
  rack = "RAC" + node.name.split('-').last.split('.').first.to_s

  template File.join( node["cassandra"]["conf_dir"], "cassandra-rackdc.properties" ) do
    source "cassandra-rackdc.properties.erb"
    owner node.cassandra.user
    group node.cassandra.user
    mode  0644
    variables :datacenter => datacenter, :rack => rack
  end
  
  service "cassandra" do
    action :restart
  end
  
end
