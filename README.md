# Vagrant boxes
Generate vagrant boxes to be used as in a Vagrantfile

E.g.
```ruby
Vagrant.configure("2") do |config|
	config.vm.box = "debian-6-amd64"
	config.vm.box_url = "http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box"
	config.vm.network :private_network, ip: "10.10.10.10"
end
```

Currently we have four flavour of boxes ready to be used:

- debian-6-amd64
- debian-6-amd64-plain
- debian-7-amd64
- debian-7-amd64-plain

where `-plain` is a bare-bones box without puppet nor ruby installed.

To generate a box, invoke `<path>/<box-type>/create.sh` e.g.
`Projects/vagrant-boxes/debian-6-amd64/create.sh`



