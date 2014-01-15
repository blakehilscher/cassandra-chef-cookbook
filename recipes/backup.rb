directory "/root/.aws" do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

template "/root/.aws/config" do
  source "backup/aws_config.erb"
  owner "root"
  group "root"
  mode  0600
end


directory File.join(node["cassandra"]["conf_dir"], "backup") do
  owner node["cassandra"]["user"]
  group node["cassandra"]["user"]
  mode 0755
  action :create
end

template File.join(node["cassandra"]["conf_dir"], "backup/backup.sh") do
  source "backup/backup.sh.erb"
  owner node["cassandra"]["user"]
  group node["cassandra"]["user"]
  mode  0744
end

template File.join(node["cassandra"]["conf_dir"], "backup/restore.sh") do
  source "backup/restore.sh.erb"
  owner node["cassandra"]["user"]
  group node["cassandra"]["user"]
  mode  0744
end

template File.join(node["cassandra"]["conf_dir"], "backup/restore_deploy.sh") do
  source "backup/restore_deploy.sh.erb"
  owner node["cassandra"]["user"]
  group node["cassandra"]["user"]
  mode  0744
end