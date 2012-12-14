package 'knockd'

service 'knockd' do
  action :nothing
  supports :start => true, :stop => true, :restart => true
end

node['knockd']['rules'].each do |name, rule|
  if node['knockd']['rules'][name]['sequence']['type'] == 'random'
    sequence_size = node['knockd']['rules'][name]['sequence']['ports_sequence']
    node.set_unless['knockd']['rules'][name]['sequence'] = generate_sequence(sequence_size).join(',')
  else
    node.set_unless['knockd']['rules'][name]['sequence'] = node['knockd']['rules'][name]['sequence']['ports_sequence']
  end
end

template '/etc/knockd.conf' do
  variables :knockd => node['knockd']
  notifies :restart, "service[knockd]"
end

template '/etc/default/knockd' do
  variables :option => node['knockd']['options']
  notifies :restart, "service[knockd]"
end