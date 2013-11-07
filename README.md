# Vagrant boxes
Generate [Vagrant](http://www.vagrantup.com/) boxes with [packer](http://www.packer.io/) for your `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
	config.vm.box = "debian-6-amd64"
	config.vm.box_url = "http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box"
end
```

### Available boxes (hosted on S3)
The `-plain` versions do not contain "git", "puppet" or "ruby".

- [debian-6-amd64](http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box)
- [debian-6-amd64-plain](http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64-plain.box)
- [debian-7-amd64](http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64.box)
- [debian-7-amd64-plain](http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64-plain.box)

### Rakefile
Build, validate and upload boxes. See `rake --tasks`:
```
rake build:debian-6-amd64/default   # Build box
rake build:debian-6-amd64/plain     # Build box
[...]
rake spec:debian-6-amd64/default    # Validate box
rake spec:debian-6-amd64/plain      # Validate box
[...]
rake upload:debian-6-amd64/default  # Upload box
rake upload:debian-6-amd64/plain    # Upload box
[...]
```
