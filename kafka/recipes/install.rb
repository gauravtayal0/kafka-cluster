kafka_user = node[:kafka][:username]
install_dir = node[:kafka][:home_dir]
kafka_dir = install_dir + "/kafka_2.10-0.8.1.1"
kafka_already_installed = File.exists?(kafka_dir)

# Create a user to run the broker
user kafka_user do
  supports :manage_home => true
  home "/home/#{kafka_user}"
  shell "/bin/bash"
  action :create
end

directory install_dir do
  owner kafka_user
  group kafka_user
  mode 0755
  action :create
end

execute "Download Kafka binary" do
  command "wget '#{node[:kafka][:mirrors]}'"
  cwd install_dir
  user kafka_user
  not_if { kafka_already_installed }
end

execute "Extract Kafka binary" do
  command "tar xvfz *.tgz"
  cwd install_dir
  user kafka_user
  not_if { kafka_already_installed }
end

# Configure server.properties
template kafka_dir + "/config/server.properties" do
  source "server.properties.erb"
  mode 0644
  owner "root"
  group "root"
end

# Configure zookeeper.properties
template kafka_dir + "/config/zookeeper.properties" do
  source "zookeeper.properties.erb"
  mode 0644
  owner "root"
  group "root"
end

# Configure hosts
template "/etc/hosts" do
  source "hosts.erb"
  mode 0644
  owner "root"
  group "root"
end

directory "/tmp/zookeeper" do
  owner kafka_user
  group kafka_user
  mode 0755
  action :create
end

# Configure zookeeper.properties
template "/tmp/zookeeper/myid" do
  source "myid.erb"
  mode 0644
  owner kafka_user
  group kafka_user
end
