package "mdadm" do
  action :install
end

package "xfsprogs" do
  action :install
end

ruby_block "Create raid volume" do
  block do
    code = "
    umount /mnt
    
    yes | mdadm --create /dev/md0 --level=0 -c64 --raid-devices=2 /dev/xvdc /dev/xvdb
    echo 'DEVICE /dev/xvdc /dev/xvdb' > /etc/mdadm.conf
    mdadm --detail --scan >> /etc/mdadm.conf
    
    blockdev --setra 65536 /dev/md0
    mkfs.xfs -f /dev/md0
    mkdir -p /mnt/md0 && mount -t xfs -o noatime /dev/md0 /mnt/md0
    cd /mnt/md0
    
    perl -ne 'print if $_ !~ /mnt/' /etc/fstab > /etc/fstab.2
    echo '#/dev/md0  /mnt  xfs    defaults 0 0' >> /etc/fstab.2
    mv /etc/fstab.2 /etc/fstab"
    %x{#{code}}
  end
  not_if { Dir.exists?("/mnt/md0") }
end