# Vagrant boxes
Store a `Vagrantfile` like this:
```ruby
Vagrant.configure("2") do |config|
	config.vm.box = "debian-6-amd64"
	config.vm.box_url = "http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box"
	config.vm.network :private_network, ip: "10.10.10.10"
end
```

Then run `vagrant up` to download and launch the box.
