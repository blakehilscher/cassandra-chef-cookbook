cassandra_version = "1.2.9"

default[:cassandra] = {
  :cluster_name => "Test Cluster",
  :initial_token => "",
  :package => 'dsc12',
  :version => cassandra_version,
  :tarball => {
    :url => "http://www.eu.apache.org/dist/cassandra/#{cassandra_version}/apache-cassandra-#{cassandra_version}-bin.tar.gz",
    :md5 => "8e02796b43e4d09a763f15758210519b"
  },
  :user => "cassandra",
  :jvm  => {
    :xms => 32,
    :xmx => 512
  },
  :limits => {
    :memlock => 'unlimited',
    :nofile  => 48000
  },
  :read_request_timeout_in_ms     => 5000,
  :range_request_timeout_in_ms    => 10000,
  :write_request_timeout_in_ms    => 2000,
  :cas_contention_timeout_in_ms   => 1000,
  :truncate_request_timeout_in_ms => 60000,
  
  :backup => {
    :bucket_name    => 'cassandra-archive',
    :keyspaces      => ['system'],
  },
  
  :installation_dir => "/usr/local/cassandra",
  :bin_dir          => "/usr/local/cassandra/bin",
  :lib_dir          => "/usr/local/cassandra/lib",
  :conf_dir         => "/etc/cassandra/",
  :data_dir         => false,
  # commit log, data directory, saved caches and so on are all stored under the data root. MK.
  :data_root_dir    => "/var/lib/cassandra/",
  :commitlog_dir    => "/var/lib/cassandra/",
  :log_dir          => "/var/log/cassandra/",
  :listen_address   => node[:ipaddress],
  :rpc_address      => node[:ipaddress],
  :max_heap_size    => nil,
  :heap_new_size    => nil,
  :vnodes           => false,
  :seeds            => [],
  :seeds_by_role    => false,
  :concurrent_reads => 32,
  :concurrent_writes => 32,
  :snitch           => 'SimpleSnitch',
  :start_native_transport => true,
  :availability_zones => {
    'us-east-1a' => 'dc1',
  }
}
