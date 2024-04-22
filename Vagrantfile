# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :
$update_channel = 'alpha'
$ip = "10.1.1.10"

Vagrant.require_version ">= 1.6.0"

# Make sure the vagrant-ignition plugin is installed
required_plugins = %w(vagrant-ignition)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.vm.box = "coreos-#{$update_channel}"
  config.vm.box_url = "https://#{$update_channel}.release.core-os.net/amd64-usr/current/coreos_production_vagrant_virtualbox.json"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 4096
    vb.cpus = 1
    vb.check_guest_additions = false
    vb.functional_vboxsf = false
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]

    config.ignition.config_obj = vb
  end

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.hostname = "omotenashi-dev"
  config.vm.network "private_network", ip: $ip

  if Vagrant::Util::Platform.windows? || Vagrant::Util::Platform.linux?
    config.vm.synced_folder "../", "/var/apps", type: "rsync", rsync__exclude: [".git/", ".vagrant/", "log/", "tmp/", "*.lock"]
  else
    config.vm.synced_folder "../", "/var/apps", :nfs => true,  :mount_options => ['nolock,vers=3,udp']
  end

  config.ignition.ip = $ip
  config.ignition.hostname = "omotenashi-dev"
#  config.ignition.drive_name = "config"
  config.ignition.path = './config.ign'
  config.ignition.enabled = true
end
