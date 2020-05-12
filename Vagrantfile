Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "Ubuntu"
  config.vm.network "forwarded_port", guest: 8080, host: 80
  config.vm.provision "shell", path: "install_LAMP.sh"
  config.vm.provision "shell", path: "install_WP.sh", args: ["test.com", "test", "leomacedo"]
  config.vm.provision "shell", path: "create_DB.sh", args: "leomacedo"
end