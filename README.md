Vagrant boxes
=============
Generate [Vagrant](http://www.vagrantup.com/) boxes with [packer](http://www.packer.io/).

Available Virtualbox images
---------------------------
The `-plain` versions do not contain "git", "puppet" or "ruby".

- debian-6-amd64: http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64.box
- debian-6-amd64-plain: http://s3.cargomedia.ch/vagrant-boxes/debian-6-amd64-plain.box
- debian-7-amd64: http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64.box
- debian-7-amd64-plain: http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64-plain.box

Example `Vagrantfile`:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7-amd64'
  config.vm.box_url = 'http://s3.cargomedia.ch/vagrant-boxes/debian-7-amd64.box'
end
```

Available Amazon Machine Images (AMI)
--------------------------------------------------------
| Type                   | eu-west-1    | us-east-1    |
| ---------------------- |--------------|--------------|
| debian-7-amd64         | ami-a8d929df | ami-1341467a |
| debian-7-amd64-plain   | ami-c0da2ab7 | ami-3740475e |

Example `Vagrantfile` (using the [vagrant AWS provider plugin](https://github.com/mitchellh/vagrant-aws)):
```ruby
Vagrant.configure('2') do |config|
  config.vm.provider :aws do |aws, override|
    override.vm.box = 'dummy'
    override.vm.box_url = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'
    override.ssh.username = 'admin'
    override.ssh.private_key_path = '~/.ssh/<private-key>.pem'

    aws.access_key_id = '<aws-access-key>'
    aws.secret_access_key = '<aws-secret-key>'
    aws.keypair_name = '<keypair-name>'

    aws.ami = 'ami-a8d929df'
    aws.region = 'eu-west-1'
    aws.instance_type = 'm3.medium'
    aws.security_groups = '<security-group-id>'
  end
end

```

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
