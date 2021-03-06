cassandra_version = "1.2.9"

default[:cassandra] = {
  :cluster_name => "Test Cluster",
  :phi_convict_threshold => 8,
  :stream_throughput_outbound_megabits_per_sec => 50,
  :compaction_throughput_mb_per_sec => 16,
  :key_cache_size_in_mb => 100,
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
    :xmx => 512,
    :xss => 256
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
    :bucket_name          => 'cassandra-archive',
    :access_key_id        => '',
    :secret_access_key    => '',
    :region               => '',
    # keyspaces to backup
    :keyspaces            => {
      :system => ['local', 'schema_columnfamilies', 'schema_columns', 'schema_keyspaces'],
    }
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
  :max_heap_size    => '6144M',
  :heap_new_size    => '600M',
  :vnodes           => false,
  :seeds            => [],
  :seeds_by_role    => false,
  :concurrent_reads => 32,
  :concurrent_writes => 32,
  :snitch           => 'SimpleSnitch',
  :start_native_transport => true,
  :availability_zones => {
    'us-east-1a' => 'dc1'
  },
  :auto_bootstrap => true,
}
