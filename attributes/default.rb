default['knockd'] = {
  'options' => {
    'start_knockd' => 1,
    'knockd_opts' => '-i eth0',
    'logfile' => 'UseSyslog'
  },
  'rules' => {
    'openclosessh' => {
      'sequence' => {
        'type' => 'normal',
        'ports_sequence' => '2000, 3000, 4000'
      },
      'cmd_timeout' => 10,
      'seq_timeout' => 5,
      'tcpflags' => 'syn',
      'start_command' => '/usr/sbin/iptables -A INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
      'stop_command' => '/usr/sbin/iptables -D INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT'
    }
  }
}