placement = node.name.split('-').last
rack = "RAC"

template "/etc/profile.d/cassandra.sh" do
  source "profile/cassandra.sh.erb"
  owner 'root'
  group 'root'
  mode  0744
  variables :placement => placement, :rack => rack
end
