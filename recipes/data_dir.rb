if node.cassandra.data_dir
    
  directory node.cassandra.data_dir do
    owner node.cassandra.user
    group node.cassandra.user
    mode 0755
    action :create
  end
  
  bash "Copy data from data_root_dir to data_dir" do
    user node.cassandra.user
    code [
      "cp -r #{node.cassandra.data_root_dir}* #{node.cassandra.data_dir}",
      "mv #{node.cassandra.data_root_dir} #{node.cassandra.data_root_dir.gsub(/\/$/,'')}-#{Time.now.to_i}"
    ].join(';')
    only_if { File.exist?( node.cassandra.data_root_dir ) and not File.symlink?( node.cassandra.data_root_dir.gsub(/\/$/,'') ) }
  end
  
  bash "link data_dir to data_root_dir" do
    user "root"
    code "ln -s #{node.cassandra.data_dir} #{node.cassandra.data_root_dir.gsub(/\/$/,'')}"
    not_if { ::File.exist?(node.cassandra.data_root_dir) }
  end
  
  bash "ensure correct permissions on cassandra.data_dir" do
    user "root"
    code "chown -R #{node.cassandra.user}:#{node.cassandra.user} #{node.cassandra.data_dir}"
  end
  
  service "cassandra" do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
  
end