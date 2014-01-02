template File.join(node["cassandra"]["conf_dir"], "backup.sh") do
  source "backup.sh.erb"
  owner node["cassandra"]["user"]
  group node["cassandra"]["user"]
  mode  0744
end