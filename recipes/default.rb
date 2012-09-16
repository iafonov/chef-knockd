package 'knockd'

service 'knockd' do
  action :nothing
  supports :start => true, :stop => true, :restart => true
end

node['knockd']['rules'].each do |name, rule|
  sequence_size = node['knockd']['rules'][name]['sequence_size']
  node.set_unless['knockd']['rules'][name]['sequence'] = generate_sequence(sequence_size)
end

template '/etc/knockd.conf' do
  variables :rules => node['knockd']['rules']
  notifies :restart, "service[knockd]"
end

cookbook_file '/etc/default/knockd' do
  notifies :restart, "service[knockd]"
end