include_recipe "java::default"

kafka_user = node[:kafka][:username]
kafka_dir = node[:kafka][:install_dir] + "/kafka_2.10-0.8.1.1"
log_dir = node[:kafka][:log_dir]
max_heap = node[:kafka][:max_heap]

directory log_dir do
  owner kafka_user
  group kafka_user
  mode 0755
  action :create
end

execute "Start single-instance zookeeper cluster" do
  command "./bin/zookeeper-server-start.sh config/zookeeper.properties >> #{log_dir}/zookeeper.log 2>&1 &"
  cwd kafka_dir
  user kafka_user
end

execute "Start single-instance Kafka broker" do
  command "KAFKA_HEAP_OPTS='-Xmx#{max_heap} -Xms#{max_heap}' ./bin/kafka-server-start.sh config/server.properties >> #{log_dir}/kafka.log 2>&1 &"
  cwd kafka_dir
  user kafka_user
end

