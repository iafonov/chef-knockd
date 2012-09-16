# chef-knockd

Cookbook manages [knockd](https://help.ubuntu.com/community/PortKnocking) port-knock server.

## Requirements

### Platform

* Debian, Ubuntu

## Dependencies

To utilize port knocking, the server must use a firewall. See [ufw](https://github.com/opscode-cookbooks/ufw) and [firewall](https://github.com/opscode-cookbooks/firewall) cookbooks.

## Attributes

### Rules

This example attributes set would add rule that will open SSH for 10 seconds and will generate 3 random ports to knock to. Array of ports would be stored in `['knockd']['rules']['ssh']['sequence']` attribute.

```ruby
['knockd']['rules']['ssh'] = {
  'sequence_size' => 3,
  'port' => 22,
  'timeout' => 10
}
```

## Usage

Add custom rules and enjoy. SSH rule is included by default.

## Important note

This cookbook will not disable port automatically. You have to shoot your leg yourself:

`$ ufw delete allow 22` (think twice before running it)

© 2012 [Igor Afonov](https://iafonov.github.com) MIT License