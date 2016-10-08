include_recipe "java::default"

kafka_user = node[:kafka][:username]
kafka_dir = node[:kafka][:home_dir] + "/kafka_2.10-0.8.1.1"
log_dir = node[:kafka][:log_dir]
max_heap = node[:kafka][:max_heap]

directory log_dir do
  owner kafka_user
  group kafka_user
  mode 0755
  action :create
end

execute "Stop Kafka broker" do
  command "./bin/kafka-server-stop.sh"
  cwd kafka_dir
  user kafka_user
end

execute "Stop zookeeper" do
  command "./bin/zookeeper-server-stop.sh"
  cwd kafka_dir
  user kafka_user
end
