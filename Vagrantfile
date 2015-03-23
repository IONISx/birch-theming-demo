require 'fileutils'

Vagrant.require_version ">= 1.5.3"

VAGRANTFILE_API_VERSION = "2"

IP_ADDR = "192.168.33.42"
MEMORY = 4096
CPU_COUNT = 2

BASE_DIR =    File.dirname(__FILE__)
THEME_DIR =   File.join(BASE_DIR, "src", "theme")
SCRIPTS_DIR = File.join(BASE_DIR, "scripts")

if !Vagrant.has_plugin?('vagrant-hostsupdater')
  print "Installing vagrant plugin vagrant-hostsupdater..."
  res = %x(bash -c "vagrant plugin install vagrant-hostsupdater")
  puts " done!"
  puts "You need to rerun your command now."
  exit 1
end

if !File.exists?(THEME_DIR)
  FileUtils.mkdir_p(THEME_DIR)
  print "Cloning theme..."
  res = %x(git clone git@github.com:IONISx/edx-theme.git #{THEME_DIR} > /dev/null 2>&1)
  puts " done!"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box     = "birch-fullstack"
  config.vm.box_url = "http://files.edx.org/vagrant-images/20150224-birch-fullstack.box"

  config.vm.synced_folder  ".", "/vagrant", disabled: true
  config.ssh.insert_key = true

  config.vm.network :private_network, ip: IP_ADDR
  config.hostsupdater.aliases = ["platform.localhost"]

  config.vm.synced_folder "#{THEME_DIR}", "/edx/app/edxapp/themes/ionisx", :create => true, nfs: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", MEMORY.to_s]
    vb.customize ["modifyvm", :id, "--cpus", CPU_COUNT.to_s]

    # Allow DNS to work for Ubuntu 12.10 host
    # http://askubuntu.com/questions/238040/how-do-i-fix-name-service-for-vagrant-client
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision "shell", path: File.join(SCRIPTS_DIR, "provision.sh"), privileged: true
  config.vm.provision "shell", path: File.join(SCRIPTS_DIR, "init.sh"), privileged: false
end
