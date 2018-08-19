# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
nodes = YAML.load_file('inventory.yml')

Vagrant.configure(2) do |config|

  nodes.each do |nodes|
      config.vm.define nodes["name"] do |node|
          node.vm.box = nodes["box"]
          node.vm.hostname = nodes["name"]
          node.vm.box_check_update = nodes["check_updates"]
          node.vm.network nodes["net"], ip: nodes["ip"]
          if nodes["forward_host_port"] and nodes["forward_guest_port"]
            node.vm.network "forwarded_port", guest: nodes["forward_host_port"], host: nodes["forward_guest_port"]
          end
          node.vm.provider "virtualbox" do |vb|
             vb.gui = nodes["gui"]
             vb.cpus = nodes["cpus"]
             vb.memory = nodes["mem"]
          end
          if nodes["privileged_scripts"]
            nodes["privileged_scripts"].each do |privileged_script|
              node.vm.provision "shell", path: privileged_script, privileged: true
            end
          end
          if nodes["scripts"]
            nodes["scripts"].each do |script|
              node.vm.provision "shell", path: script, privileged: false
            end
          end
      end
  end
end
