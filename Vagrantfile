# -*- mode: ruby -*-
# vi: set ft=ruby :

DEFAULTS = {
  :cpu    => 2,
  :memory => 512,
  :env    => 'vagrant',
}.freeze

hosts = {
  'hieracrypta' => {
    :ip   => '10.16.34.10',
  },
}

Vagrant.configure("2") do |config|
  hosts.each do |name, host|
    host = DEFAULTS.merge(host)
    config.vm.define name do |host_config|
      host_config.vm.box = 'precise64'
      host_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
      host_config.vm.hostname = "#{name}.internal"
      host_config.vm.network :private_network, ip: host[:ip]

      # Allows building up a VM but referencing your local file system.
      # host_config.vm.synced_folder "../", "/nfs", nfs: true

      host_config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id,
                      "--name", name,
                      "--memory", host[:memory],
                      "--cpus", host[:cpu]]
      end

      config.vm.provision :shell, path: "tools/bootstrap-vagrant"

    end
  end
end
