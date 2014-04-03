Vagrant boxes
=============
Generate [Vagrant](http://www.vagrantup.com/) boxes with [packer](http://www.packer.io/).

There are three flavors available:
- `*-plain`: Minimalistic Debian with Virtualbox-additions where applicable.
- `*-default`: Like above, plus `git`, `rsync`, `ruby` and `puppet`.
- `*-cm`: Like above, plus [CM framework dependencies](https://github.com/cargomedia/puppet-cm).

Available Virtualbox images
---------------------------

- debian-7-amd64-plain: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-plain.box`
- debian-7-amd64-default: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-default.box`
- debian-7-amd64-cm: `http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-cm.box`

Example `Vagrantfile`:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7-amd64-default'

  config.vm.provider :virtualbox do |virtualbox, override|
    override.vm.box_url = 'http://vagrant-boxes.cargomedia.ch/virtualbox/debian-7-amd64-default.box'
  end
end
```

Available Amazon Machine Images (AMI)
-------------------------------------
Based on [official Debian AMIs](https://wiki.debian.org/Cloud/AmazonEC2Image/Wheezy).
Available regions: `eu-west-1`, `us-east-1`.

- debian-7-amd64-plain: `http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-plain.box`
- debian-7-amd64-default: `http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-default.box`
- debian-7-amd64-cm: `http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-cm.box`

Example `Vagrantfile` (using the [vagrant AWS provider plugin](https://github.com/mitchellh/vagrant-aws)):
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7-amd64-default'

  config.vm.provider :aws do |aws, override|
    override.vm.box_url = 'http://vagrant-boxes.cargomedia.ch/aws/debian-7-amd64-default.box'
    override.ssh.username = 'admin'
    override.ssh.private_key_path = '~/.ssh/<private-key>.pem'

    aws.region = 'eu-west-1'
    aws.instance_type = 'm3.large'
    aws.access_key_id = '<aws-access-key>'
    aws.secret_access_key = '<aws-secret-key>'
    aws.keypair_name = '<keypair-name>'
    aws.security_groups = '<security-group-id>'

    aws.block_device_mapping = [
      {
        'DeviceName' => '/dev/sda',
        'VirtualName' => 'root',
        'Ebs.VolumeSize' => 100,
        'Ebs.DeleteOnTermination' => true,
        'Ebs.VolumeType' => 'io1',
        'Ebs.Iops' => 2000
      }
    ]
  end
end
```

Development (building and uploading)
------------------------------------
Download required puppet modules using [librarian-puppet](http://librarian-puppet.com/):
```
cd puppet
librarian-puppet install
```

Rake parameters:
- builder: A list of builders to use (Default: all builders)
- aws_key_id: AWS key id
- aws_key_secret: AWS key secret
- vagrant_cloud_username: Vagrant Cloud username
- vagrant_cloud_access_token: Vagrant Cloud access token

```
rake build    # Build all boxes
rake spec     # Run serverspec tests (virtualbox build only!)
rake release  # Release boxes to S3 and Vagrant Cloud
```
