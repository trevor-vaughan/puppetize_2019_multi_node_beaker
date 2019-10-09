# multi_node

#### Table of Contents

* [Description](#description)
* [Setup](#setup)
* [Usage](#usage)

## Description

This module was created for Puppetize 2019 to demonstrate the multi-node
testing abilities of Beaker as run via PDK.

## Setup

To run the acceptance tests provided by this module, you will need to install
[Vagrant](https://vagrantup.com) from the Vagrant website (do NOT use a
vendor-provided Vagrant). You will also need to install
[VirtualBox](https://www.virtualbox.org/).

You will need to ensure that your use can successfully run `vagrant up` on a
sample Vagrantfile prior to proceeding to run the tests.

One is provided below for reference. Simply drop it into a file called
`Vagrantfile` and run `vagrant up`. If you get no errors, you're ready to go
and can run `vagrant destroy -f centos7` to remove it.

```
Vagrant.configure("2") do |c|
  c.vm.define 'centos7' do |v|
    v.vm.synced_folder ".", "/vagrant", disabled: true
    v.vm.hostname = 'centos7'
    v.vm.box = 'centos/7'
    v.vm.box_check_update = 'true'
    v.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', '512', '--cpus', '1']
    end
  end
end
```

## Usage

The acceptance tests provided by this module for demonstration can be found in
`spec/acceptance` and can be run using `pdk bundle exec beaker`.

Suites provided by this module can be shown by running `pdk bundle exec rake beaker:suites[nil]`.

You can run the default (single-node) suite using `pdk bundle exec rake beaker:suites`.

You can run the cross-node suite using `pdk bundle exec rake beaker:suites[cross_node]`.
