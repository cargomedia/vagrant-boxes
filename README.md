Vagrant boxes
=============
Generate [Vagrant](http://www.vagrantup.com/) boxes with [packer](http://www.packer.io/) for your `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
	config.vm.box = "debian-6-amd64"
	config.vm.box_url = "http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box"
end
```

Available Virtualbox images
---------------------------
The `-plain` versions do not contain "git", "puppet" or "ruby".

- debian-6-amd64: http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box
- debian-6-amd64-plain: http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64-plain.box
- debian-7-amd64: http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64.box
- debian-7-amd64-plain: http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64-plain.box

Available Amazon Machine Images (AMI)
-----------------------------------------
| Type                   | eu-west-1    |
| ---------------------- |--------------|
| debian-7-amd64         | ami-c8d727bf |

Build Virtualbox images
-----------------------
Build, validate and upload Virtualbox images.
```
rake build:debian-7-amd64/default
rake spec:debian-7-amd64/default
rake upload:debian-7-amd64/default
```

Build AMI images
----------------
Build AMIs based on [official Debian AMIs](https://wiki.debian.org/Cloud/AmazonEC2Image/Wheezy).
```
rake build:debian-7-amd64/default builder=aws AWS_ACCESS_KEY='<access-key>' AWS_SECRET_KEY='<secret-key>'
```
