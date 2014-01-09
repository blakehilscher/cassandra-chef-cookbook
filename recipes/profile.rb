placement = node.name.split('-').last
rack = "RAC" + placement.split('.').first.to_s

template "/etc/profile.d/cassandra.sh" do
  source "profile/cassandra.sh.erb"
  owner 'root'
  group 'root'
  mode  0744
  variables :placement => placement, :rack => rack
end
