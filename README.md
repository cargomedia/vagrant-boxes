Vagrant boxes
=============
Generate [Vagrant](http://www.vagrantup.com/) boxes with [packer](http://www.packer.io/).
The `-plain` versions do not contain "git", "puppet" or "ruby".

Available Virtualbox images
---------------------------

- debian-6-amd64: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-6-amd64-default.box`
- debian-6-amd64-plain: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-6-amd64-plain.box`
- debian-7-amd64: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-default.box`
- debian-7-amd64-plain: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-plain.box`

Example `Vagrantfile`:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7-amd64'

  config.vm.provider :virtualbox do |aws, override|
    override.vm.box_url = 'http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-default.box'
  end
end
```

Available Amazon Machine Images (AMI)
-------------------------------------
Based on [official Debian AMIs](https://wiki.debian.org/Cloud/AmazonEC2Image/Wheezy).
Available regions: `eu-west-1`, `us-east-1`.

- debian-7-amd64: `http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-default.box`
- debian-7-amd64-plain: `http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-plain.box`

Example `Vagrantfile` (using the [vagrant AWS provider plugin](https://github.com/mitchellh/vagrant-aws)):
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7-amd64'

  config.vm.provider :aws do |aws, override|
    override.vm.box_url = 'http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-default.box'
    override.ssh.username = 'admin'
    override.ssh.private_key_path = '~/.ssh/<private-key>.pem'

    aws.region = 'eu-west-1'
    aws.instance_type = 'm3.medium'
    aws.access_key_id = '<aws-access-key>'
    aws.secret_access_key = '<aws-secret-key>'
    aws.keypair_name = '<keypair-name>'
    aws.security_groups = '<security-group-id>'
  end
end
```

Development (building and uploading)
------------------------------------
Build a box:
```
rake build:debian-7-amd64-default [aws_key_id=<access-key>] [aws_key_secret=<secret-key>] [builder=<builder-only>]
```

Run serverspec tests (virtualbox build only!):
```
rake spec:debian-7-amd64-default
```

Upload box to S3:
```
rake upload:debian-7-amd64-default [aws_key_id=<access-key>] [aws_key_secret=<secret-key>] [builder=<builder-only>]
```
