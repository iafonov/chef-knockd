# chef-knockd

Cookbook manages [knockd](https://help.ubuntu.com/community/PortKnocking) port-knock server.

Port knocking is a simple method to grant remote access without leaving a port constantly open. This preserves your server from port scanning and script kiddie attacks.

## Requirements

### Platform

* Debian, Ubuntu 
* It should work on RHEL/CentOS and ArchLinux

## Dependencies

To utilize port knocking, the server must have a firewall. See [ufw](https://github.com/opscode-cookbooks/ufw), [firewall](https://github.com/opscode-cookbooks/firewall) and [iptables](https://github.com/opscode-cookbooks/iptables) cookbooks for more information about managing and running firewall with chef.

## Attributes

### Rules

This example attributes set would add rule that will open SSH for 10 seconds and will generate 3 random ports to knock to. Array of ports would be stored in `['knockd']['rules']['openclosessh']['sequence']` attribute.

```ruby
['knockd']['rules']['openclosessh'] = {
  'sequence' => {
      'type' => 'random',
      'ports_sequence' => 3
  },
  'cmd_timeout' => 10,
  'seq_timeout' => 5,
  'start_command' => '/usr/sbin/iptables -A INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
  'stop_command' => '/usr/sbin/iptables -D INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT'
}
```

On the other hand if you prefer a default sequence of ports you can change `['knockd']['rules']['openclosessh']['sequence']['type']` to `normal`.

```ruby
['knockd']['rules']['openclosessh'] = {
  'sequence' => {
      'type' => 'normal',
      'ports_sequence' => '2000, 3000, 4000'
  },
  'cmd_timeout' => 10,
  'seq_timeout' => 5,
  'start_command' => '/usr/sbin/iptables -A INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
  'stop_command' => '/usr/sbin/iptables -D INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT'
}
```

## Usage

Add custom rules and enjoy. SSH port rule is included by default.

## Automation of port-knocking when using random ports

Add this to Rakefile in your chef repository:

```ruby
require 'socket'

desc 'ssh to a node specified by name'
task :ssh, :node_name do |t, args|
  node = search(:node, args[:node_name]).first
  knock_nodes(node)
  exec("ssh #{node.fqdn}")
end

def knock_nodes(node)
  knock_ports = node['knockd']['rules']['ssh']['sequence'] rescue []
  knock_ports.each{ |port| knock(node.fqdn, port) }
end

def knock(host, port)
  s = Socket.new(Socket::Constants::AF_INET, Socket::Constants::SOCK_STREAM, 0)
  sa = Socket.pack_sockaddr_in(port, host)
  s.connect_nonblock(sa)
end
```

Run this task to knock node and ssh to it:

```bash
$ rake ssh[staging]
```
## Important note

This cookbook will not disable port automatically. You'll have to shoot your leg yourself:

```bash
$ ufw delete allow 22 # (think twice and test everything before running it)
```

© 2012 [Igor Afonov](https://iafonov.github.com) MIT License
© 2012 [Aldo Borrero](https://aldoborrero.com)