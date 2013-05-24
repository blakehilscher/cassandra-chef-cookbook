mdadm "/dev/md0" do
  devices [ "/dev/sdb", "/dev/sdc" ]
  level 0
  chunk 64
  action [ :create, :assemble ]
end

mount "/raid0/" do
  device "/dev/md0"
  fstype "ext3"
end